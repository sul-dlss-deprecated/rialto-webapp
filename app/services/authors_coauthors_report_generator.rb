# frozen_string_literal: true

# Generate a downloadable report consisting of a list of institutions the
# authors in that department have collaborated with, along with number of collaborations
class AuthorsCoauthorsReportGenerator
  def self.generate
    new.generate
  end

  def generate
    database_values.each_with_object([]) do |row, o|
      p1 = Person.find_by(uri: row[0])
      p2 = Person.find_by(uri: row[1])
      o << [p1.name, p1.institution_name, p1.department_name,
            p2.name, p2.institution_name, p2.department_name,
            row[2]]
    end
  end

  private

  def database_values
    ActiveRecord::Base.connection.execute(sql).values
  end

  def sql
    'SELECT p1.uri, p2.uri, count(*) FROM people p1 ' \
    'LEFT OUTER JOIN people_publications pp ON p1.id = pp.person_id ' \
    'LEFT OUTER JOIN publications pub ON pp.publication_id = pub.id ' \
    'LEFT OUTER JOIN people_publications pp2 ON pub.id = pp2.publication_id ' \
    'LEFT OUTER JOIN people p2 ON pp2.person_id = p2.id ' \
    'WHERE p2.id != p1.id ' \
    'GROUP BY p1.uri, p2.uri ' \
    'ORDER BY p1.uri'
  end
end
