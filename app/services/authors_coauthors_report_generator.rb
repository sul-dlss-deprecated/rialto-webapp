# frozen_string_literal: true

require 'csv'

# Generate a downloadable report consisting of a list of institutions the
# authors in that department have collaborated with, along with number of collaborations
class AuthorsCoauthorsReportGenerator
  # @param [Integer] department_id the identifier of the deparment to generate
  #   the report for
  def self.generate(department_id)
    new(department_id).generate
  end

  # @param [Integer] department_id the identifier of the deparment to generate
  #   the report for
  def initialize(deparment_id)
    @organization = Organization.find(deparment_id)
  end

  # @return [String] a csv report
  def generate
    CSV.generate do |csv|
      database_values.each do |row|
        csv << expand_people(row)
      end
    end
  end

  private

  attr_reader :organization

  def expand_people(row)
    p1 = Person.find_by(uri: row['uri1'])
    p2 = Person.find_by(uri: row['uri2'])
    [p1.name, p1.institution_name, p1.department_name,
     p2.name, p2.institution_name, p2.department_name,
     row['count']]
  end

  # @return [ActiveRecord::Result]
  def database_values
    conn = ActiveRecord::Base.connection
    conn.exec_query(sql, 'SQL', [[nil, organization.uri]])
  end

  def sql
    'SELECT p1.uri as uri1, p2.uri as uri2, count(*) FROM people p1 ' \
    'LEFT OUTER JOIN people_publications pp ON p1.id = pp.person_id ' \
    'LEFT OUTER JOIN publications pub ON pp.publication_id = pub.id ' \
    'LEFT OUTER JOIN people_publications pp2 ON pub.id = pp2.publication_id ' \
    'LEFT OUTER JOIN people p2 ON pp2.person_id = p2.id ' \
    'WHERE p2.id != p1.id AND ' \
    "p1.metadata->>'department' = $1 " \
    'GROUP BY p1.uri, p2.uri ' \
    'ORDER BY p1.uri'
  end
end
