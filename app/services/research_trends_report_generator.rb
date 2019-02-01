# frozen_string_literal: true

require 'set'

# Generate a downloadable report consisting of publications counts by year for concepts
# limited by organizations
# rubocop:disable Metrics/ClassLength
class ResearchTrendsReportGenerator < ReportGenerator
  # @param [Enumerator] output Enumerator to which to write the CSV.
  # @param [Integer] org_uri the identifier of the org to generate
  #   the report for
  # @param [Integer] start_year the minimum publication year on the report
  # @param [Integer] end_year the maximum publication year on the report
  def initialize(output, org_uri: nil, start_year:, end_year:)
    @csv = output
    @organization = Organization.find(org_uri) if org_uri
    @start_year = start_year
    @end_year = end_year
  end

  # @return [String] a csv report
  # rubocop:disable Metrics/AbcSize
  def generate
    years_totals, concepts, concept_totals = extract_years_and_concepts(database_values)
    return if years_totals.empty?

    csv << CSV.generate_line(generate_headers)
    concept_totals.each do |concept, total|
      csv << CSV.generate_line(generate_crosstab_row(concept, concepts[concept], total))
    end
    csv << CSV.generate_line(generate_totals(years_totals))
  end
  # rubocop:enable Metrics/AbcSize

  private

  attr_reader :organization, :start_year, :end_year, :csv

  # rubocop:disable Metrics/AbcSize
  # rubocop:disable Metrics/MethodLength
  def extract_years_and_concepts(database_values)
    years_totals = {}
    concepts = {}
    concept_totals = {}
    database_values.each do |row|
      years_totals[row['year'].to_i] ||= 0
      years_totals[row['year'].to_i] += row['count']
      concepts[row['concept']] ||= {}
      concepts[row['concept']][row['year'].to_i] = row['count']
      concept_totals[row['concept']] ||= 0
      concept_totals[row['concept']] += row['count']
    end
    [years_totals, concepts, sort_concept_totals(concept_totals)]
  end
  # rubocop:enable Metrics/AbcSize
  # rubocop:enable Metrics/MethodLength

  def sort_concept_totals(concept_totals)
    concept_totals.sort_by { |_concept, total| -total }.to_h
  end

  def generate_headers
    headers = ['Concept']
    Range.new(start_year, end_year).each do |year|
      headers << year.to_s
    end
    headers << 'Total'
    headers
  end

  def generate_crosstab_row(concept, concept_years, total)
    crosstab_row = [concept]
    Range.new(start_year, end_year).each do |year|
      crosstab_row << concept_years.fetch(year.to_i, 0)
    end
    crosstab_row << total
    crosstab_row
  end

  def generate_totals(years_totals)
    totals_row = ['TOTAL']
    grand_total = 0
    Range.new(start_year, end_year).each do |year|
      totals_row << years_totals.fetch(year, 0)
      grand_total += years_totals.fetch(year, 0)
    end
    totals_row << grand_total
    totals_row
  end

  # @return [ActiveRecord::Result]
  def database_values
    conn = ActiveRecord::Base.connection
    params = [[nil, start_year], [nil, end_year]]
    if organization
      params << [nil, Person.org_metadata_field(organization.type)]
      params << [nil, organization.uri]
    end
    conn.exec_query(sql, 'SQL', params)
  end

  # rubocop:disable Metrics/MethodLength
  def sql
    sql_str = +'SELECT con.name as concept, dpub.created_year as year, count(*) as count ' \
    "FROM (SELECT DISTINCT pub.uri, pub.metadata -> 'created_year' as created_year, " \
    "jsonb_array_elements_text(pub.metadata -> 'concepts') as concept_uri FROM publications pub " \
    'INNER JOIN people_publications pp on pub.uri=pp.publication_uri ' \
    'INNER JOIN people p on p.uri=pp.person_uri ' \
    "WHERE pub.metadata -> 'created_year' >= $1 AND " \
    "pub.metadata -> 'created_year' <= $2"
    sql_str << if organization
                 ' AND p.metadata -> $3 ? $4 '
               else
                 # This makes sure that all people includes the same people as when filtering by school / dept.
                 " AND (jsonb_array_length(p.metadata -> 'schools') != 0 OR jsonb_array_length(p.metadata -> 'departments') != 0)"
               end
    sql_str << ') as dpub ' \
    'INNER JOIN concepts con on con.uri=dpub.concept_uri ' \
    'GROUP BY con.name, dpub.created_year ' \
    'UNION ALL ' \
    "SELECT 'No concept' as concept, dpub.created_year as year, count(*) as count " \
    "FROM (SELECT DISTINCT pub.metadata -> 'created_year' as created_year " \
    'FROM publications pub ' \
    'INNER JOIN people_publications pp on pub.uri=pp.publication_uri ' \
    'INNER JOIN people p on p.uri=pp.person_uri ' \
    "WHERE pub.metadata -> 'created_year' >= $1 AND " \
    "pub.metadata -> 'created_year' <= $2"
    sql_str << if organization
                 ' AND p.metadata -> $3 ? $4 '
               else
                 # This makes sure that all people includes the same people as when filtering by school / dept.
                 " AND (jsonb_array_length(p.metadata -> 'schools') != 0 OR jsonb_array_length(p.metadata -> 'departments') != 0)"
               end

    sql_str << " AND jsonb_array_length(pub.metadata -> 'concepts') = 0 " \
    ') as dpub ' \
    'GROUP BY dpub.created_year ' \
    'ORDER BY count desc, concept'
  end
  # rubocop:enable Metrics/MethodLength
end
# rubocop:enable Metrics/ClassLength
