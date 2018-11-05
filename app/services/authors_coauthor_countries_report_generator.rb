# frozen_string_literal: true

require 'csv'

# Generate a downloadable report consisting of a list of countries the
# authors in that organization have collaborated with, along with number of collaborations
class AuthorsCoauthorCountriesReportGenerator
  # @param params [ActionController::Parameters]
  # @option params [String] :org_uri the identifier of the org to generate
  #   the report for
  def self.generate(params)
    new(params[:org_uri], params[:start_year], params[:end_year]).generate
  end

  # @param [Integer] org_uri the identifier of the deparment to generate
  #   the report for
  def initialize(org_uri, start_year, end_year)
    @organization = Organization.find(org_uri)
    @start_year = start_year
    @end_year = end_year
  end

  # @return [String] a csv report
  def generate
    CSV.generate do |csv|
      csv << ['Co-Author Country',
              'Number of Collaborations']
      database_values.each do |row|
        csv << [row['country'], row['count']]
      end
    end
  end

  private

  attr_reader :organization, :start_year, :end_year

  # @return [ActiveRecord::Result]
  def database_values
    conn = ActiveRecord::Base.connection
    conn.exec_query(sql, 'SQL', [[nil, Person.org_metadata_field(organization.type)], [nil, organization.uri],
                                 [nil, start_year], [nil, end_year]])
  end

  # rubocop:disable Metrics/MethodLength
  def sql
    'SELECT p2i.country as country, count(*) as count FROM people p1 ' \
    'LEFT OUTER JOIN people_publications pp ON p1.uri = pp.person_uri ' \
    'LEFT OUTER JOIN publications pub ON pp.publication_uri = pub.uri ' \
    'LEFT OUTER JOIN people_publications pp2 ON pub.uri = pp2.publication_uri ' \
    'LEFT OUTER JOIN (SELECT p2.uri, p2ia.value as country ' \
    "FROM people p2, jsonb_array_elements_text(p2.metadata -> 'country_labels') p2ia) p2i ON pp2.person_uri = p2i.uri " \
    'WHERE p2i.uri != p1.uri AND ' \
    'p1.metadata -> $1 ? $2 AND ' \
    "pub.metadata -> 'created_year' >= $3 AND " \
    "pub.metadata -> 'created_year' <= $4 " \
    'GROUP BY p2i.country ' \
    'ORDER BY count(*) desc, p2i.country'
  end
  # rubocop:enable Metrics/MethodLength
end
