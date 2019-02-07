# frozen_string_literal: true

# Generate a downloadable report consisting of a list of countries the
# authors in that organization have collaborated with, along with number of collaborations
class AuthorsCoauthorCountriesReportGenerator < ReportGenerator
  # @param [Enumerator] output Enumerator to which to write the CSV.
  # @param [Integer] org_uri the identifier of the deparment to generate
  #   the report for
  # @param [Integer] start_year the minimum publication year on the report
  # @param [Integer] end_year the maximum publication year on the report
  # @param [String] country_label name of the country to limit details by
  def initialize(output, org_uri: nil, start_year:, end_year:, country_label: nil)
    @csv = output
    @organization = Organization.find(org_uri) if org_uri
    @start_year = start_year
    @end_year = end_year
    @country_label = country_label
  end

  # @return [String] a csv report
  def generate
    csv << CSV.generate_line(['Co-Author Country',
                              'Number of Collaborations'])
    database_values(sql).each do |row|
      csv << CSV.generate_line([row['country'], row['count']])
    end
  end

  # @return [String] a csv report
  # rubocop:disable Metrics/AbcSize
  # rubocop:disable Metrics/MethodLength
  def details
    csv << CSV.generate_line(['Collab Country', 'Collab Name', 'Name', 'Title', 'Year'])

    offset = 0
    limit_size = 10_000
    loop do
      db_values = database_values(sql(detail: true), offset: offset, limit: limit_size)
      db_values.each do |row|
        csv << CSV.generate_line([row['country'], row['collab_name'], row['name'], row['title'], row['created_year']])
      end
      offset += limit_size
      break if db_values.length != limit_size
    end
  end
  # rubocop:enable Metrics/AbcSize
  # rubocop:enable Metrics/MethodLength

  private

  attr_reader :organization, :start_year, :end_year, :country_label, :csv

  # @return [ActiveRecord::Result]
  # rubocop:disable Metrics/AbcSize
  # rubocop:disable Metrics/MethodLength
  def database_values(sql, limit: nil, offset: nil)
    conn = ActiveRecord::Base.connection
    params = [[nil, start_year], [nil, end_year]]
    if organization
      params << [nil, Person.org_metadata_field(organization.type)]
      params << [nil, organization.uri]
    end

    params << [nil, country_label] if country_label
    params << [nil, limit] if limit
    params << [nil, offset] if offset
    conn.exec_query(sql, 'SQL', params)
  end

  # rubocop:disable Metrics/PerceivedComplexity
  def sql(detail = false)
    holder = 0
    sql_str = +'SELECT '
    sql_str << if detail
                 "p2i.country as country, p1.name as name, p2i.name as collab_name, pub.metadata ->> 'title' as title, " \
                 "pub.metadata -> 'created_year' as created_year "
               else
                 'p2i.country as country, count(*) as count '
               end
    sql_str << 'FROM people p1 ' \
    'LEFT OUTER JOIN people_publications pp ON p1.uri = pp.person_uri ' \
    'LEFT OUTER JOIN publications pub ON pp.publication_uri = pub.uri ' \
    'LEFT OUTER JOIN people_publications pp2 ON pub.uri = pp2.publication_uri ' \
    'LEFT OUTER JOIN (SELECT p2.uri, p2.name, p2ia.value as country ' \
    'FROM people p2, jsonb_array_elements_text(' \
    "CASE WHEN jsonb_array_length(p2.metadata -> 'country_labels') > 0 THEN p2.metadata -> 'country_labels' " \
    "ELSE '[\"Unknown\"]' END) p2ia) p2i ON pp2.person_uri = p2i.uri " \
    'WHERE p2i.uri != p1.uri AND ' \
    "pub.metadata -> 'created_year' >= $#{holder += 1} AND " \
    "pub.metadata -> 'created_year' <= $#{holder += 1} "
    sql_str << if organization
                 " AND p1.metadata -> $#{holder += 1} ? $#{holder += 1} "
               else
                 # This makes sure that all people includes the same people as when filtering by school / dept.
                 " AND (jsonb_array_length(p1.metadata -> 'schools') != 0 OR jsonb_array_length(p1.metadata -> 'departments') != 0) "
               end
    sql_str << " AND p2i.country = $#{holder += 1} " if country_label
    sql_str << if detail
                 "ORDER BY p2i.country LIMIT $#{holder += 1} OFFSET $#{holder + 1}"
               else
                 'GROUP BY p2i.country ' \
                 'ORDER BY count(*) desc, p2i.country'
               end
  end
  # rubocop:enable Metrics/MethodLength
  # rubocop:enable Metrics/AbcSize
  # rubocop:enable Metrics/PerceivedComplexity
end
