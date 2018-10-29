# frozen_string_literal: true

require 'csv'

# Generate a downloadable report consisting of a list of institutions the
# authors in that department have collaborated with, along with number of collaborations
class AuthorsCoauthorsReportGenerator
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
      csv << ['Author', 'Institution', 'Department', 'Co-Author',
              'Co-Author Institution',
              'Number of Collaborations', 'Co-Author Country']
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
    [p1.name, join_org_names(p1.institution_entities), join_org_names(p1.department_entities),
     p2.name, join_org_names(p2.institution_entities),
     row['count'],
     join_person_countries(p2)]
  end

  def join_org_names(orgs)
    orgs.to_a.map(&:name).uniq.sort.join('; ')
  end

  def join_person_countries(person)
    person.country_labels.sort.join('; ')
  end

  # @return [ActiveRecord::Result]
  def database_values
    conn = ActiveRecord::Base.connection
    conn.exec_query(sql, 'SQL', [[nil, organization.uri]])
  end

  def sql
    'SELECT p1.uri as uri1, p2.uri as uri2, count(*) FROM people p1 ' \
    'LEFT OUTER JOIN people_publications pp ON p1.uri = pp.person_uri ' \
    'LEFT OUTER JOIN publications pub ON pp.publication_uri = pub.uri ' \
    'LEFT OUTER JOIN people_publications pp2 ON pub.uri = pp2.publication_uri ' \
    'LEFT OUTER JOIN people p2 ON pp2.person_uri = p2.uri ' \
    'WHERE p2.uri != p1.uri AND ' \
    "p1.metadata -> 'departments' ? $1 "  \
    'GROUP BY p1.uri, p2.uri ' \
    'ORDER BY p1.uri'
  end
end
