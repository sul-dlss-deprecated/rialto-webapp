# frozen_string_literal: true

require 'set'

# Generate a downloadable report consisting of publications counts by year for concepts
# limited by organizations
class ResearchTrendsReportGenerator < ReportGenerator
  # @param [Integer] org_uri the identifier of the org to generate
  #   the report for
  # @param [Integer] start_year the minimum publication year on the report
  # @param [Integer] end_year the maximum publication year on the report
  def initialize(org_uri:, start_year:, end_year:)
    @organization = Organization.find(org_uri)
    @start_year = start_year
    @end_year = end_year
  end

  # @return [String] a csv report
  def generate
    CSV.generate do |csv|
      years, concepts, concept_totals = extract_years_and_concepts(database_values)
      unless years.empty?
        csv << generate_headers(years)
        concept_totals.each do |concept, total|
          csv << generate_crosstab_row(concept, concepts[concept], years, total)
        end
      end
    end
  end

  private

  attr_reader :organization, :start_year, :end_year

  # rubocop:disable Metrics/AbcSize
  # rubocop:disable Metrics/MethodLength
  def extract_years_and_concepts(database_values)
    years = Set.new
    concepts = {}
    concept_totals = {}
    database_values.each do |row|
      years << row['year'].to_i
      concepts[row['concept']] ||= {}
      concepts[row['concept']][row['year'].to_i] = row['count']
      concept_totals[row['concept']] ||= 0
      concept_totals[row['concept']] += row['count']
    end
    [years, concepts, sort_concept_totals(concept_totals)]
  end
  # rubocop:enable Metrics/AbcSize
  # rubocop:enable Metrics/MethodLength

  def sort_concept_totals(concept_totals)
    concept_totals.sort_by { |_concept, total| -total }.to_h
  end

  def generate_headers(years)
    headers = ['Concept']
    Range.new(years.min, years.max).each do |year|
      headers << year.to_s
    end
    headers << 'Total'
    headers
  end

  def generate_crosstab_row(concept, concept_years, years, total)
    crosstab_row = [concept]
    Range.new(years.min, years.max).each do |year|
      crosstab_row << concept_years.fetch(year, 0)
    end
    crosstab_row << total
    crosstab_row
  end

  # @return [ActiveRecord::Result]
  def database_values
    conn = ActiveRecord::Base.connection
    conn.exec_query(sql, 'SQL', [[nil, Person.org_metadata_field(organization.type)],
                                 [nil, organization.uri],
                                 [nil, start_year],
                                 [nil, end_year]])
  end

  # rubocop:disable Metrics/MethodLength
  def sql
    'SELECT con.name as concept, dpub.created_year as year, count(*) as count ' \
    "FROM (SELECT DISTINCT pub.uri, pub.metadata -> 'created_year' as created_year, " \
    "jsonb_array_elements_text(pub.metadata -> 'concepts') as concept_uri FROM publications pub " \
    'INNER JOIN people_publications pp on pub.uri=pp.publication_uri ' \
    'INNER JOIN people p on p.uri=pp.person_uri ' \
    'WHERE p.metadata -> $1 ? $2 AND '\
    "pub.metadata -> 'created_year' >= $3 AND " \
    "pub.metadata -> 'created_year' <= $4 " \
    ') as dpub ' \
    'INNER JOIN concepts con on con.uri=dpub.concept_uri ' \
    'GROUP BY con.name, dpub.created_year ' \
    'UNION ALL ' \
    "SELECT 'No concept' as concept, dpub.created_year as year, count(*) as count " \
    "FROM (SELECT DISTINCT pub.metadata -> 'created_year' as created_year " \
    'FROM publications pub ' \
    'INNER JOIN people_publications pp on pub.uri=pp.publication_uri ' \
    'INNER JOIN people p on p.uri=pp.person_uri ' \
    'WHERE p.metadata -> $1 ? $2 AND '\
    "pub.metadata -> 'created_year' >= $3 AND " \
    "pub.metadata -> 'created_year' <= $4 AND " \
    "jsonb_array_length(pub.metadata -> 'concepts') = 0 " \
    ') as dpub ' \
    'GROUP BY dpub.created_year ' \
    'ORDER BY count desc, concept'
  end
  # rubocop:enable Metrics/MethodLength
end
