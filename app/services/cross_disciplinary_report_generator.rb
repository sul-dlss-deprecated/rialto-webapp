# frozen_string_literal: true

require 'set'

# Generate a downloadable report consisting of publications counts by year for institutes
# limted by concept
class CrossDisciplinaryReportGenerator < ReportGenerator
  # @param [Integer] concept_uri the identifier of the concept to generate
  #   the report for
  def initialize(concept_uri: nil)
    @concept = Concept.find(concept_uri) if concept_uri
  end

  # @return [String] a csv report
  def generate
    CSV.generate do |csv|
      years, institutes = extract_years_and_institutes(database_values)
      unless years.empty?
        csv << generate_headers(years)
        institutes.each do |institute, institute_years|
          csv << generate_crosstab_row(institute, institute_years, years)
        end
      end
    end
  end

  private

  attr_reader :concept

  def extract_years_and_institutes(database_values)
    years = Set.new
    institutes = {}
    database_values.each do |row|
      years << row['year'].to_i
      institutes[row['institute']] ||= {}
      institutes[row['institute']][row['year'].to_i] = row['count']
    end
    [years, institutes]
  end

  def generate_headers(years)
    headers = ['Institute']
    Range.new(years.min, years.max).each do |year|
      headers << year.to_s
    end
    headers << 'Total'
  end

  def generate_crosstab_row(institute, institute_years, years)
    crosstab_row = [institute]
    total = 0
    Range.new(years.min, years.max).each do |year|
      crosstab_row << institute_years.fetch(year, 0)
      total += crosstab_row.last
    end
    crosstab_row << total
  end

  # @return [ActiveRecord::Result]
  def database_values
    conn = ActiveRecord::Base.connection
    params = []
    params << [nil, concept.uri] if concept
    conn.exec_query(sql, 'SQL', params)
  end

  def sql
    sql_str = +"SELECT o.name as institute, pub.metadata -> 'created_year' as year, count(*) as count FROM publications pub " \
    'INNER JOIN people_publications pp on pp.publication_uri = pub.uri '\
    "INNER JOIN (SELECT p.uri, jsonb_array_elements_text(p.metadata -> 'institutes') as institute FROM people p) pi on pi.uri = pp.person_uri " \
    'INNER JOIN organizations o on o.uri = pi.institute '
    sql_str << "WHERE pub.metadata -> 'concepts' ? $1 " if concept
    sql_str << "GROUP BY o.name, pub.metadata -> 'created_year' " \
    "ORDER BY o.name, pub.metadata -> 'created_year'"
  end
end
