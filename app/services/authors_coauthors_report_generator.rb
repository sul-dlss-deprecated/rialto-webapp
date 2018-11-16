# frozen_string_literal: true

# Generate a downloadable report consisting of a list of authors the
# authors in that organization have collaborated with, along with number of collaborations
class AuthorsCoauthorsReportGenerator < ReportGenerator
  # @param [Integer] org_uri the identifier of the organization to generate
  #   the report for
  # @param [Integer] start_year the minimum publication year on the report
  # @param [Integer] end_year the maximum publication year on the report
  def initialize(org_uri: nil, start_year:, end_year:)
    @organization = Organization.find(org_uri) if org_uri
    @start_year = start_year
    @end_year = end_year
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

  attr_reader :organization, :start_year, :end_year

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
    Array.wrap(person.country_labels).sort.join('; ')
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
    sql_str = +'SELECT p1.uri as uri1, p2.uri as uri2, count(*) FROM people p1 ' \
    'LEFT OUTER JOIN people_publications pp ON p1.uri = pp.person_uri ' \
    'LEFT OUTER JOIN publications pub ON pp.publication_uri = pub.uri ' \
    'LEFT OUTER JOIN people_publications pp2 ON pub.uri = pp2.publication_uri ' \
    'LEFT OUTER JOIN people p2 ON pp2.person_uri = p2.uri ' \
    'WHERE p2.uri != p1.uri AND ' \
    "pub.metadata -> 'created_year' >= $1 AND " \
    "pub.metadata -> 'created_year' <= $2"
    sql_str << if organization
                 ' AND p1.metadata -> $3 ? $4 '
               else
                 # This makes sure that all people includes the same people as when filtering by school / dept.
                 " AND (jsonb_array_length(p1.metadata -> 'schools') != 0 OR jsonb_array_length(p1.metadata -> 'departments') != 0)"
               end
    sql_str << 'GROUP BY p1.uri, p2.uri ' \
               'ORDER BY count(*) desc, p1.uri, p2.uri'
  end
  # rubocop:enable Metrics/MethodLength
end
