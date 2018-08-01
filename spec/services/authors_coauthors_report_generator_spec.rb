# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AuthorsCoauthorsReportGenerator do
  subject(:report) { described_class.generate }

  context 'with some authors and publications' do
    before do
      Organization.create!(uri: 'http://example.com/institution1',
                           metadata: {
                             name: 'Stanford'
                           })

      Organization.create!(uri: 'http://example.com/institution2',
                           metadata: {
                             name: 'Harvard'
                           })

      Organization.create!(uri: 'http://example.com/institution3',
                           metadata: {
                             name: 'Ghent'
                           })

      Organization.create!(uri: 'http://example.com/institution4',
                           metadata: {
                             name: 'Brussels U'
                           })

      Organization.create!(uri: 'http://example.com/department1',
                           metadata: {
                             name: 'Chemistry'
                           })
      Organization.create!(uri: 'http://example.com/department2',
                           metadata: {
                             name: 'Biochemistry'
                           })

      Organization.create!(uri: 'http://example.com/department3',
                           metadata: {
                             name: 'Informatics'
                           })

      Organization.create!(uri: 'http://example.com/department4',
                           metadata: {
                             name: 'Computer Science'
                           })

      Organization.create!(uri: 'http://example.com/department5',
                           metadata: {
                             name: 'Informatics'
                           })

      Organization.create!(uri: 'http://example.com/department6',
                           metadata: {
                             name: 'Medicine'
                           })

      p1 = Person.create!(uri: 'http://example.com/person1',
                          metadata: {
                            name: 'John Smith',
                            department: 'http://example.com/department1',
                            institutionalAffiliation: 'http://example.com/institution1'
                          })
      p2 = Person.create!(uri: 'http://example.com/person2',
                          metadata: {
                            name: 'Jane Smith',
                            department: 'http://example.com/department2',
                            institutionalAffiliation: 'http://example.com/institution2'
                          })
      p3 = Person.create!(uri: 'http://example.com/person3',
                          metadata: {
                            name: 'Jane Okoye',
                            department: 'http://example.com/department3',
                            institutionalAffiliation: 'http://example.com/institution3'
                          })
      p4 = Person.create!(uri: 'http://example.com/person4',
                          metadata: {
                            name: 'Patrick Hoch',
                            department: 'http://example.com/department4',
                            institutionalAffiliation: 'http://example.com/institution3'
                          })

      p5 = Person.create!(uri: 'http://example.com/person5',
                          metadata: {
                            name: 'Peter Smith',
                            department: 'http://example.com/department5',
                            institutionalAffiliation: 'http://example.com/institution4'
                          })
      p6 = Person.create!(uri: 'http://example.com/person6',
                          metadata: {
                            name: 'Lady Red',
                            department: 'http://example.com/department6',
                            institutionalAffiliation: 'http://example.com/institution1'
                          })
      Publication.create!(uri: 'http://example.com/publication1',
                          authors: [p1, p2])
      2.upto(11) do |n|
        Publication.create!(uri: "http://example.com/publication#{n}",
                            authors: [p1, p3, p4])
      end
      12.upto(21) do |n|
        Publication.create!(uri: "http://example.com/publication#{n}",
                            authors: [p1, p5])
      end
      22.upto(31) do |n|
        Publication.create!(uri: "http://example.com/publication#{n}",
                            authors: [p6, p3])
      end
    end

    it 'is a report' do
      expect(CSV.parse(report)).to eq [
        ['John Smith', 'Stanford', 'Chemistry', 'Jane Smith', 'Harvard', 'Biochemistry', '1'],
        ['John Smith', 'Stanford', 'Chemistry', 'Jane Okoye', 'Ghent', 'Informatics', '10'],
        ['John Smith', 'Stanford', 'Chemistry', 'Patrick Hoch', 'Ghent', 'Computer Science', '10'],
        ['John Smith', 'Stanford', 'Chemistry', 'Peter Smith', 'Brussels U', 'Informatics', '10'],
        ['Jane Smith', 'Harvard', 'Biochemistry', 'John Smith', 'Stanford', 'Chemistry', '1'],
        ['Jane Okoye', 'Ghent', 'Informatics', 'John Smith', 'Stanford', 'Chemistry', '10'],
        ['Jane Okoye', 'Ghent', 'Informatics', 'Patrick Hoch', 'Ghent', 'Computer Science', '10'],
        ['Jane Okoye', 'Ghent', 'Informatics', 'Lady Red', 'Stanford', 'Medicine', '10'],
        ['Patrick Hoch', 'Ghent', 'Computer Science', 'John Smith', 'Stanford', 'Chemistry', '10'],
        ['Patrick Hoch', 'Ghent', 'Computer Science', 'Jane Okoye', 'Ghent', 'Informatics', '10'],
        ['Peter Smith', 'Brussels U', 'Informatics', 'John Smith', 'Stanford', 'Chemistry', '10'],
        ['Lady Red', 'Stanford', 'Medicine', 'Jane Okoye', 'Ghent', 'Informatics', '10']
      ]
    end
  end
end
