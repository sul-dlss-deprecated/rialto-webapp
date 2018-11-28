# frozen_string_literal: true

# Generate a downloadable report consisting of a list of authors the
# authors in that organization have collaborated with, along with number of collaborations
class AuthorsCoauthorsReportGenerator < ReportGenerator
  # @param [Integer] org_uri the identifier of the organization to generate
  #   the report for
  # @param [Integer] start_year the minimum publication year on the report
  # @param [Integer] end_year the maximum publication year on the report
  def initialize(org_uri: nil, start_year:, end_year:, limit: nil, offset: nil)
    @organization = Organization.find(org_uri) if org_uri
    @start_year = start_year
    @end_year = end_year
    @offset = offset
    @limit = limit
  end

  # @return [String] a csv report
  def generate
    CSV.generate do |csv|
      csv << ['Author', 'Institution', 'Department', 'Co-Author',
              'Co-Author Institution',
              'Number of Collaborations', 'Co-Author Country']
      database_values(sql).each do |row|
        csv << expand_row(row)
      end
    end
  end

  # @return [String] a csv report
  def count
    CSV.generate do |csv|
      csv << ['Count']
      database_values("select count(*) from ( #{sql} ) sub").each do |row|
        csv << [row['count']]
      end
    end
  end

  private

  attr_reader :organization, :start_year, :end_year, :offset, :limit

  def expand_row(row)
    [row['name1'], join_list(row['institutions1']), join_list(row['departments1']),
     row['name2'], join_list(row['institutions2']),
     row['count'], join_list(row['countries2'])]
  end

  def join_list(list)
    return '' if !list || list == 'null'
    JSON.parse(list).sort.join('; ')
  end

  # @return [ActiveRecord::Result]
  # rubocop:disable Metrics/AbcSize
  def database_values(sql)
    conn = ActiveRecord::Base.connection
    params = [[nil, start_year], [nil, end_year]]
    if organization
      params << [nil, Person.org_metadata_field(organization.type)]
      params << [nil, organization.uri]
    end
    params << [nil, offset] if offset
    params << [nil, limit] if limit
    conn.exec_query(sql, 'SQL', params)
  end
  # rubocop:enable Metrics/AbcSize

  # rubocop:disable Metrics/MethodLength
  # rubocop:disable Metrics/AbcSize
  def sql
    holder = 0
    sql_str = +"SELECT p1.name as name1, p1.metadata->'institution_labels' as institutions1, " \
    "p1.metadata->'department_labels' as departments1, p2.name as name2, p2.metadata->'institution_labels' as institutions2, " \
    "p2.metadata->'country_labels' as countries2, count(*) FROM people p1 " \
    'LEFT OUTER JOIN people_publications pp ON p1.uri = pp.person_uri ' \
    'LEFT OUTER JOIN publications pub ON pp.publication_uri = pub.uri ' \
    'LEFT OUTER JOIN people_publications pp2 ON pub.uri = pp2.publication_uri ' \
    'LEFT OUTER JOIN people p2 ON pp2.person_uri = p2.uri ' \
    'WHERE p2.uri != p1.uri AND ' \
    "pub.metadata -> 'created_year' >= $#{holder += 1} AND " \
    "pub.metadata -> 'created_year' <= $#{holder += 1}"
    sql_str << if organization
                 " AND p1.metadata -> $#{holder += 1} ? $#{holder += 1} "
               else
                 # This makes sure that all people includes the same people as when filtering by school / dept.
                 " AND (jsonb_array_length(p1.metadata -> 'schools') != 0 OR jsonb_array_length(p1.metadata -> 'departments') != 0)"
               end
    sql_str << "GROUP BY p1.name, p1.metadata->'institution_labels', p1.metadata->'department_labels', p2.name, " \
               "p2.metadata->'institution_labels', p2.metadata->'country_labels' " \
               'ORDER BY count(*) desc, p1.name, p2.name'
    sql_str << " OFFSET $#{holder += 1}" if offset
    sql_str << " LIMIT $#{holder + 1}" if limit
    sql_str
  end
  # rubocop:enable Metrics/MethodLength
  # rubocop:enable Metrics/AbcSize
end
