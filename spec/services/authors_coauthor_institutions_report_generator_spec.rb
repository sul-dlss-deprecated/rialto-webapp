# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AuthorsCoauthorInstitutionsReportGenerator do
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
                            departments: [],
                            institutionalAffiliations: ['http://example.com/institution2'],
                            country_labels: ['United States']
                          })
      p3 = Person.create!(uri: 'http://example.com/person3',
                          name: 'Jane Okoye',
                          metadata: {
                            departments: [],
                            institutionalAffiliations: ['http://example.com/institution3'],
                            country_labels: ['Belgium']

                          })
      p4 = Person.create!(uri: 'http://example.com/person4',
                          name: 'Patrick Hoch',
                          metadata: {
                            departments: [],
                            institutionalAffiliations: ['http://example.com/institution3'],
                            country_labels: ['Belgium']
                          })

      p5 = Person.create!(uri: 'http://example.com/person5',
                          name: 'Peter Smith',
                          metadata: {
                            departments: [],
                            institutionalAffiliations: ['http://example.com/institution3',
                                                        'http://example.com/institution4'],
                            country_labels: ['Belgium']
                          })
      p6 = Person.create!(uri: 'http://example.com/person6',
                          name: 'Lady Red',
                          metadata: {
                            departments: [],
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
      # rubocop:disable Style/WordArray
      expect(CSV.parse(report)).to eq [
        ['Co-Author Institution', 'Number of Collaborations'],
        ['Ghent', '30'],
        ['Brussels U', '10'],
        ['Harvard', '1']
      ]
      # rubocop:enable Style/WordArray
    end
  end
end
