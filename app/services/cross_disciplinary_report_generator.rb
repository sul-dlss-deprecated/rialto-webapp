# frozen_string_literal: true

require 'set'

# Generate a downloadable report consisting of publications counts by year for institutes
# limted by concept
class CrossDisciplinaryReportGenerator < ReportGenerator
  # @param [Integer] concept_uri the identifier of the concept to generate
  #   the report for
  def initialize(concept_uri:)
    @concept = Concept.find(concept_uri)
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
    headers
  end

  def generate_crosstab_row(institute, institute_years, years)
    crosstab_row = [institute]
    Range.new(years.min, years.max).each do |year|
      crosstab_row << institute_years.fetch(year, 0)
    end
    crosstab_row
  end

  # @return [ActiveRecord::Result]
  def database_values
    conn = ActiveRecord::Base.connection
    conn.exec_query(sql, 'SQL', [[nil, concept.uri]])
  end

  def sql
    "SELECT o.name as institute, pub.metadata -> 'created_year' as year, count(*) as count FROM publications pub " \
    'INNER JOIN people_publications pp on pp.publication_uri = pub.uri '\
    "INNER JOIN (SELECT p.uri, jsonb_array_elements_text(p.metadata -> 'institutes') as institute FROM people p) pi on pi.uri = pp.person_uri " \
    'INNER JOIN organizations o on o.uri = pi.institute ' \
    "WHERE pub.metadata -> 'concepts' ? $1 " \
    "GROUP BY o.name, pub.metadata -> 'created_year' " \
    "ORDER BY o.name, pub.metadata -> 'created_year'"
  end
end
