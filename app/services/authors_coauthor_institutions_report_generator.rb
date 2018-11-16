# frozen_string_literal: true

# Generate a downloadable report consisting of a list of institutions the
# authors in that organization have collaborated with, along with number of collaborations
class AuthorsCoauthorInstitutionsReportGenerator < ReportGenerator
  # @param [Integer] org_uri the identifier of the deparment to generate
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
      csv << ['Co-Author Institution',
              'Number of Collaborations']
      database_values.each do |row|
        csv << [row['name'], row['count']]
      end
    end
  end

  private

  attr_reader :organization, :start_year, :end_year

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
    sql_str = +'SELECT o.name as name, count(*) as count FROM people p1 ' \
    'LEFT OUTER JOIN people_publications pp ON p1.uri = pp.person_uri ' \
    'LEFT OUTER JOIN publications pub ON pp.publication_uri = pub.uri ' \
    'LEFT OUTER JOIN people_publications pp2 ON pub.uri = pp2.publication_uri ' \
    'LEFT OUTER JOIN (SELECT p2.uri, p2ia.value as institution ' \
    "FROM people p2, jsonb_array_elements_text(p2.metadata -> 'institutionalAffiliations') p2ia) p2i ON pp2.person_uri = p2i.uri " \
    'LEFT OUTER JOIN organizations o on p2i.institution = o.uri ' \
    'WHERE p2i.uri != p1.uri AND ' \
    "pub.metadata -> 'created_year' >= $1 AND " \
    "pub.metadata -> 'created_year' <= $2 "
    sql_str << if organization
                 ' AND p1.metadata -> $3 ? $4 '
               else
                 # This makes sure that all people includes the same people as when filtering by school / dept.
                 " AND (jsonb_array_length(p1.metadata -> 'schools') != 0 OR jsonb_array_length(p1.metadata -> 'departments') != 0)"
               end

    sql_str << 'GROUP BY o.name ' \
      'ORDER BY count(*) desc, o.name'
  end
  # rubocop:enable Metrics/MethodLength
end
