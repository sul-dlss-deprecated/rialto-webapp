# frozen_string_literal: true

require 'csv'

# Generate a downloadable report consisting of a list of countries the
# authors in that department have collaborated with, along with number of collaborations
class AuthorsCoauthorCountriesReportGenerator
  # @param params [ActionController::Parameters]
  # @option params [String] :department_uri the identifier of the deparment to generate
  #   the report for
  def self.generate(params)
    department_uri = params[:department_uri]
    new(department_uri).generate
  end

  # @param [Integer] department_uri the identifier of the deparment to generate
  #   the report for
  def initialize(department_uri)
    @organization = Organization.find(department_uri)
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

  attr_reader :organization

  # @return [ActiveRecord::Result]
  def database_values
    conn = ActiveRecord::Base.connection
    conn.exec_query(sql, 'SQL', [[nil, organization.uri]])
  end

  def sql
    'SELECT p2i.country as country, count(*) as count FROM people p1 ' \
    'LEFT OUTER JOIN people_publications pp ON p1.uri = pp.person_uri ' \
    'LEFT OUTER JOIN publications pub ON pp.publication_uri = pub.uri ' \
    'LEFT OUTER JOIN people_publications pp2 ON pub.uri = pp2.publication_uri ' \
    'LEFT OUTER JOIN (SELECT p2.uri, p2ia.value as country ' \
    "FROM people p2, jsonb_array_elements_text(p2.metadata -> 'country_labels') p2ia) p2i ON pp2.person_uri = p2i.uri " \
    'WHERE p2i.uri != p1.uri AND ' \
    "p1.metadata -> 'departments' ? $1 " \
    'GROUP BY p1.uri, p2i.country ' \
    'ORDER BY count(*) desc'
  end
end
