# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AuthorsCoauthorsReportGenerator do
  subject(:report) { described_class.generate(department_uri: department.uri) }

  let(:department) do
    Organization.create!(uri: 'http://example.com/department1',
                         name: 'Chemistry')
  end

  context 'with some authors and publications' do
    before do
      Organization.create!(uri: 'http://example.com/institution1',
                           name: 'Stanford')

      Organization.create!(uri: 'http://example.com/institution2',
                           name: 'Harvard')

      Organization.create!(uri: 'http://example.com/institution3',
                           name: 'Ghent')

      Organization.create!(uri: 'http://example.com/institution4',
                           name: 'Brussels U')

      Organization.create!(uri: 'http://example.com/department2',
                           name: 'Biochemistry')

      Organization.create!(uri: 'http://example.com/department3',
                           name: 'Informatics')

      Organization.create!(uri: 'http://example.com/department4',
                           name: 'Computer Science')

      Organization.create!(uri: 'http://example.com/department5',
                           name: 'Informatics')

      Organization.create!(uri: 'http://example.com/department6',
                           name: 'Medicine')

      p1 = Person.create!(uri: 'http://example.com/person1',
                          name: 'John Smith',
                          metadata: {
                            departments: [department.uri],
                            institutionalAffiliations: ['http://example.com/institution1'],
                            country_labels: ['United States']
                          })
      p2 = Person.create!(uri: 'http://example.com/person2',
                          name: 'Jane Smith',
                          metadata: {
                            departments: ['http://example.com/department2'],
                            institutionalAffiliations: ['http://example.com/institution2'],
                            country_labels: ['United States']
                          })
      p3 = Person.create!(uri: 'http://example.com/person3',
                          name: 'Jane Okoye',
                          metadata: {
                            departments: ['http://example.com/department3'],
                            institutionalAffiliations: ['http://example.com/institution3'],
                            country_labels: ['Belgium']

                          })
      p4 = Person.create!(uri: 'http://example.com/person4',
                          name: 'Patrick Hoch',
                          metadata: {
                            departments: ['http://example.com/department4'],
                            institutionalAffiliations: ['http://example.com/institution3'],
                            country_labels: ['Belgium']
                          })

      p5 = Person.create!(uri: 'http://example.com/person5',
                          name: 'Peter Smith',
                          metadata: {
                            departments: ['http://example.com/department5', 'http://example.com/department6'],
                            institutionalAffiliations: ['http://example.com/institution3',
                                                        'http://example.com/institution4'],
                            country_labels: ['Belgium']
                          })
      p6 = Person.create!(uri: 'http://example.com/person6',
                          name: 'Lady Red',
                          metadata: {
                            departments: ['http://example.com/department6'],
                            institutionalAffiliations: ['http://example.com/institution1'],
                            country_labels: ['Canada']
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

      # This publication shouldn't be included on the report:
      Publication.create!(uri: 'http://example.com/publication22',
                          authors: [p6, p3])
    end

    it 'is a report' do
      expect(CSV.parse(report)).to eq [
        ['Author', 'Institution', 'Department', 'Co-Author', 'Co-Author Institution',
         'Number of Collaborations', 'Co-Author Country'],
        ['John Smith', 'Stanford', 'Chemistry', 'Jane Smith', 'Harvard', '1', 'United States'],
        ['John Smith', 'Stanford', 'Chemistry', 'Jane Okoye', 'Ghent', '10', 'Belgium'],
        ['John Smith', 'Stanford', 'Chemistry', 'Patrick Hoch', 'Ghent', '10', 'Belgium'],
        ['John Smith', 'Stanford', 'Chemistry', 'Peter Smith', 'Brussels U; Ghent', '10', 'Belgium']
      ]
    end
  end
end
