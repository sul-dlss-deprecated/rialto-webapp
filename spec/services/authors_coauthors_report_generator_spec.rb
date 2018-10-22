# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AuthorsCoauthorsReportGenerator do
  subject(:report) { described_class.generate(department_uri: department.uri) }

  let(:department) do
    Organization.create!(uri: 'http://example.com/department1',
                         metadata: {
                           name: 'Chemistry'
                         })
  end

  context 'with some authors and publications' do
    before do
      Organization.create!(uri: 'http://example.com/institution1',
                           metadata: {
                             name: 'Stanford',
                             country: 'United States'
                           })

      Organization.create!(uri: 'http://example.com/institution2',
                           metadata: {
                             name: 'Harvard',
                             country: 'United States'
                           })

      Organization.create!(uri: 'http://example.com/institution3',
                           metadata: {
                             name: 'Ghent',
                             country: 'Belgium'
                           })

      Organization.create!(uri: 'http://example.com/institution4',
                           metadata: {
                             name: 'Brussels U',
                             country: 'Belgium'
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
                            departments: [department.uri],
                            institutionalAffiliations: ['http://example.com/institution1']
                          })
      p2 = Person.create!(uri: 'http://example.com/person2',
                          metadata: {
                            name: 'Jane Smith',
                            departments: ['http://example.com/department2'],
                            institutionalAffiliations: ['http://example.com/institution2']
                          })
      p3 = Person.create!(uri: 'http://example.com/person3',
                          metadata: {
                            name: 'Jane Okoye',
                            departments: ['http://example.com/department3'],
                            institutionalAffiliations: ['http://example.com/institution3']
                          })
      p4 = Person.create!(uri: 'http://example.com/person4',
                          metadata: {
                            name: 'Patrick Hoch',
                            departments: ['http://example.com/department4'],
                            institutionalAffiliations: ['http://example.com/institution3']
                          })

      p5 = Person.create!(uri: 'http://example.com/person5',
                          metadata: {
                            name: 'Peter Smith',
                            departments: ['http://example.com/department5', 'http://example.com/department6'],
                            institutionalAffiliations: ['http://example.com/institution3',
                                                        'http://example.com/institution4']
                          })
      p6 = Person.create!(uri: 'http://example.com/person6',
                          metadata: {
                            name: 'Lady Red',
                            departments: ['http://example.com/department6'],
                            institutionalAffiliations: ['http://example.com/institution1']
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
         'Co-Author Department', 'Number of Collaborations', 'Co-Author Country'],
        ['John Smith', 'Stanford', 'Chemistry', 'Jane Smith', 'Harvard', 'Biochemistry', '1', 'United States'],
        ['John Smith', 'Stanford', 'Chemistry', 'Jane Okoye', 'Ghent', 'Informatics', '10', 'Belgium'],
        ['John Smith', 'Stanford', 'Chemistry', 'Patrick Hoch', 'Ghent', 'Computer Science', '10', 'Belgium'],
        ['John Smith', 'Stanford', 'Chemistry', 'Peter Smith', 'Brussels U; Ghent', 'Informatics; Medicine', '10', 'Belgium']
      ]
    end
  end
end
