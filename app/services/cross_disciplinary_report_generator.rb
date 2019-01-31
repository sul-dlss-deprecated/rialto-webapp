# frozen_string_literal: true

require 'set'

# Generate a downloadable report consisting of publications counts by year for institutes
# limted by concept
class CrossDisciplinaryReportGenerator < ReportGenerator
  # @param [Enumerator] output Enumerator to which to write the CSV.
  # @param [Integer] concept_uri the identifier of the concept to generate
  #   the report for
  def initialize(output, concept_uri: nil, start_year: nil, end_year: nil)
    @csv = output
    @concept = Concept.find(concept_uri) if concept_uri
    @end_year = end_year.to_i || Time.now.year
    @start_year = start_year.nil? ? @end_year - 10 : start_year.to_i
  end

  # @return [String] a csv report
  def generate
    institutes = extract_years_and_institutes(database_values)
    csv << CSV.generate_line(generate_headers)
    institutes.each do |institute, institute_years|
      csv << CSV.generate_line(generate_crosstab_row(institute, institute_years))
    end
  end

  private

  attr_reader :concept, :csv, :start_year, :end_year

  def extract_years_and_institutes(database_values)
    institutes = {}
    database_values.each do |row|
      institutes[row['institute']] ||= {}
      institutes[row['institute']][row['year'].to_i] = row['count']
    end
    institutes
  end

  def generate_headers
    headers = ['Institute']
    Range.new(start_year, end_year).each do |year|
      headers << year.to_s
    end
    headers << 'Total'
  end

  def generate_crosstab_row(institute, institute_years)
    crosstab_row = [institute]
    total = 0
    Range.new(start_year, end_year).each do |year|
      crosstab_row << institute_years.fetch(year, 0)
      total += crosstab_row.last
    end
    crosstab_row << total
  end

  # @return [ActiveRecord::Result]
  def database_values
    conn = ActiveRecord::Base.connection
    params = [[nil, start_year], [nil, end_year]]
    params << [nil, concept.uri] if concept
    conn.exec_query(sql, 'SQL', params)
  end

  def sql
    sql_str = +"SELECT o.name as institute, pub.metadata -> 'created_year' as year, count(*) as count FROM publications pub " \
    'INNER JOIN people_publications pp on pp.publication_uri = pub.uri '\
    "INNER JOIN (SELECT p.uri, jsonb_array_elements_text(p.metadata -> 'institutes') as institute FROM people p) pi on pi.uri = pp.person_uri " \
    'INNER JOIN organizations o on o.uri = pi.institute ' \
    "WHERE pub.metadata -> 'created_year' >= $1 AND " \
    "pub.metadata -> 'created_year' <= $2 "
    sql_str << "AND pub.metadata -> 'concepts' ? $3 " if concept
    sql_str << "GROUP BY o.name, pub.metadata -> 'created_year' " \
    "ORDER BY o.name, pub.metadata -> 'created_year'"
  end
end
