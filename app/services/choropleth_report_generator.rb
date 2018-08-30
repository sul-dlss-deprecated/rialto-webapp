# frozen_string_literal: true

require 'csv'

# Generate a downloadable report suitable for driving the choropleth visualization.
# This report consisting of a list of countries and the count of the number of collaborations
# with institutions in those countries.
# First column is the country name
# Second column is the count of collaborations
# Third column is the country code (ISO 3166-1 alpha-3)
class ChoroplethReportGenerator
  # @param params [ActionController::Parameters]
  # @option params [String] :department_id the identifier of the deparment to generate
  #   the report for
  def self.generate(params)
    department_id = params[:department_id].to_i
    new(department_id).generate
  end

  # @param [Integer] department_id the identifier of the deparment to generate
  #   the report for
  def initialize(department_id)
    @organization = Organization.find(department_id)
  end

  # @return [String] a csv report
  def generate
    CSV.generate do |csv|
      csv << ['Country', 'Number of collaborations']
      database_values.each do |row|
        csv << [row['country'], row['count']]
      end
    end
  end

  private

  attr_reader :organization

  # @return [ActiveRecord::Result]
  def database_values
    conn = ActiveRecord::Base.connection
    conn.exec_query(sql, 'SQL', [[nil, organization.uri]])
  end

  def sql
    "SELECT o2.metadata->>'country' as country, count(*) FROM people p1 " \
    'LEFT OUTER JOIN people_publications pp ON p1.id = pp.person_id ' \
    'LEFT OUTER JOIN publications pub ON pp.publication_id = pub.id ' \
    'LEFT OUTER JOIN people_publications pp2 ON pub.id = pp2.publication_id ' \
    'LEFT OUTER JOIN people p2 ON pp2.person_id = p2.id ' \
    "LEFT OUTER JOIN organizations o2 ON p2.metadata->>'institutionalAffiliation' = o2.uri "\
    'WHERE p2.id != p1.id AND ' \
    "p1.metadata->>'department' = $1 " \
    'GROUP BY country ' \
    'ORDER BY country '
  end
end
