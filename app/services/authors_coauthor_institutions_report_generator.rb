# frozen_string_literal: true

# Generate a downloadable report consisting of a list of institutions the
# authors in that organization have collaborated with, along with number of collaborations
class AuthorsCoauthorInstitutionsReportGenerator < ReportGenerator
  # @param [Enumerator] output Enumerator to which to write the CSV.
  # @param [Integer] org_uri the identifier of the deparment to generate
  #   the report for
  # @param [Integer] start_year the minimum publication year on the report
  # @param [Integer] end_year the maximum publication year on the report
  # @param [String] institution_label name of the institution to limit details by
  def initialize(output, org_uri: nil, start_year:, end_year:, institution_label: nil)
    @csv = output
    @organization = Organization.find(org_uri) if org_uri
    @start_year = start_year
    @end_year = end_year
    @institution_label = institution_label
  end

  # @return [String] a csv report
  def generate
    csv << CSV.generate_line(['Co-Author Institution',
                              'Number of Collaborations'])
    database_values(sql).each do |row|
      csv << CSV.generate_line([row['name'], row['count']])
    end
  end

  # @return [String] a csv report
  # rubocop:disable Metrics/AbcSize
  # rubocop:disable Metrics/MethodLength
  def details
    csv << CSV.generate_line(['Co-author Institution', 'Co-Author', 'Stanford Author', 'Publication Title', 'Publication Year'])

    offset = 0
    limit_size = 10_000
    loop do
      db_values = database_values(sql(detail: true), offset: offset, limit: limit_size)
      db_values.each do |row|
        csv << CSV.generate_line([row['institution'], row['collab_name'], row['name'], row['title'], row['created_year']])
      end
      offset += limit_size
      break if db_values.length != limit_size
    end
  end
  # rubocop:enable Metrics/MethodLength

  private

  attr_reader :organization, :start_year, :end_year, :institution_label, :csv

  # @return [ActiveRecord::Result]
  def database_values(sql, limit: nil, offset: nil)
    conn = ActiveRecord::Base.connection
    params = [[nil, start_year], [nil, end_year]]
    if organization
      params << [nil, Person.org_metadata_field(organization.type)]
      params << [nil, organization.uri]
    end
    params << [nil, institution_label] if institution_label
    params << [nil, limit] if limit
    params << [nil, offset] if offset
    conn.exec_query(sql, 'SQL', params)
  end

  # rubocop:disable Metrics/MethodLength
  # rubocop:disable Metrics/PerceivedComplexity
  def sql(detail = false)
    holder = 0
    sql_str = +'SELECT '
    sql_str << if detail
                 "coalesce(o.name, 'Unknown') as institution, p1.name as name, p2i.name as collab_name, " \
                 "pub.metadata ->> 'title' as title, pub.metadata -> 'created_year' as created_year "
               else
                 "coalesce(o.name, 'Unknown') as name, count(*) as count  "
               end
    sql_str << 'FROM people p1 ' \
    'LEFT OUTER JOIN people_publications pp ON p1.uri = pp.person_uri ' \
    'LEFT OUTER JOIN publications pub ON pp.publication_uri = pub.uri ' \
    'LEFT OUTER JOIN people_publications pp2 ON pub.uri = pp2.publication_uri ' \
    'LEFT OUTER JOIN (SELECT p2.uri, p2.name, p2ia.value as institution ' \
    'FROM people p2, jsonb_array_elements_text(' \
    "CASE WHEN jsonb_array_length(p2.metadata -> 'institutions') > 0 THEN p2.metadata -> 'institutions' " \
    "ELSE '[\"Unknown\"]' END) p2ia) p2i ON pp2.person_uri = p2i.uri " \
    'LEFT OUTER JOIN organizations o on p2i.institution = o.uri ' \
    'WHERE p2i.uri != p1.uri AND ' \
    "pub.metadata -> 'created_year' >= $#{holder += 1} AND " \
    "pub.metadata -> 'created_year' <= $#{holder += 1} "
    sql_str << if organization
                 " AND p1.metadata -> $#{holder += 1} ? $#{holder += 1} "
               else
                 # This makes sure that all people includes the same people as when filtering by school / dept.
                 " AND (jsonb_array_length(p1.metadata -> 'schools') != 0 OR jsonb_array_length(p1.metadata -> 'departments') != 0)"
               end
    sql_str << " AND o.name = $#{holder += 1} " if institution_label
    sql_str << if detail
                 "ORDER BY o.name LIMIT $#{holder += 1} OFFSET $#{holder + 1}"
               else
                 'GROUP BY o.name ' \
                 'ORDER BY count(*) desc, o.name'
               end
    sql_str
  end
  # rubocop:enable Metrics/MethodLength
  # rubocop:enable Metrics/AbcSize
  # rubocop:enable Metrics/PerceivedComplexity
end
