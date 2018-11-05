# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AuthorsCoauthorsReportGenerator do
  subject(:report) { described_class.generate(org_uri: organization.uri, start_year: start_year, end_year: end_year) }

  let(:start_year) { '2016' }

  let(:end_year) { '2018' }

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
                          departments: ['http://example.com/department1'],
                          schools: ['http://example.com/school1'],
                          institutionalAffiliations: ['http://example.com/institution1'],
                          country_labels: ['United States']
                        })
    p2 = Person.create!(uri: 'http://example.com/person2',
                        name: 'Jane Smith',
                        metadata: {
                          departments: ['http://example.com/department2'],
                          schools: ['http://example.com/school2'],
                          institutionalAffiliations: ['http://example.com/institution2'],
                          country_labels: ['United States']
                        })
    p3 = Person.create!(uri: 'http://example.com/person3',
                        name: 'Jane Okoye',
                        metadata: {
                          departments: ['http://example.com/department3'],
                          schools: ['http://example.com/school3'],
                          institutionalAffiliations: ['http://example.com/institution3'],
                          country_labels: ['Belgium']

                        })
    p4 = Person.create!(uri: 'http://example.com/person4',
                        name: 'Patrick Hoch',
                        metadata: {
                          departments: ['http://example.com/department4'],
                          schools: ['http://example.com/school4'],
                          institutionalAffiliations: ['http://example.com/institution3'],
                          country_labels: ['Belgium']
                        })

    p5 = Person.create!(uri: 'http://example.com/person5',
                        name: 'Peter Smith',
                        metadata: {
                          departments: ['http://example.com/department5', 'http://example.com/department6'],
                          schools: ['http://example.com/school5', 'http://example.com/school6'],
                          institutionalAffiliations: ['http://example.com/institution3',
                                                      'http://example.com/institution4'],
                          country_labels: ['Belgium']
                        })
    p6 = Person.create!(uri: 'http://example.com/person6',
                        name: 'Lady Red',
                        metadata: {
                          departments: ['http://example.com/department6'],
                          schools: ['http://example.com/school6'],
                          institutionalAffiliations: ['http://example.com/institution1'],
                          country_labels: ['Canada']
                        })
    p7 = Person.create!(uri: 'http://example.com/person7',
                        name: 'Dude without a country',
                        metadata: {
                          departments: ['http://example.com/department6'],
                          schools: ['http://example.com/school7'],
                          institutionalAffiliations: ['http://example.com/institution1'],
                          country_labels: nil
                        })
    Publication.create!(uri: 'http://example.com/publication1',
                        metadata: {
                          created_year: 2018
                        },
                        authors: [p1, p2])
    2.upto(11) do |n|
      Publication.create!(uri: "http://example.com/publication#{n}",
                          metadata: {
                            created_year: 2017
                          },
                          authors: [p1, p3, p4])
    end

    12.upto(21) do |n|
      Publication.create!(uri: "http://example.com/publication#{n}",
                          metadata: {
                            created_year: 2016
                          },
                          authors: [p1, p5])
    end

    # This publication shouldn't be included on the report:
    Publication.create!(uri: 'http://example.com/publication22',
                        metadata: {
                          created_year: 2018
                        },
                        authors: [p6, p3])

    Publication.create!(uri: 'http://example.com/publication23',
                        metadata: {
                          created_year: 2018
                        },
                        authors: [p1, p7])
  end

  context 'when querying by department' do
    let(:organization) do
      Organization.create!(uri: 'http://example.com/department1',
                           name: 'Chemistry',
                           type: Organization::DEPARTMENT)
    end

    it 'is a report' do
      expect(CSV.parse(report)).to eq [
        ['Author', 'Institution', 'Department', 'Co-Author', 'Co-Author Institution',
         'Number of Collaborations', 'Co-Author Country'],
        ['John Smith', 'Stanford', 'Chemistry', 'Jane Smith', 'Harvard', '1', 'United States'],
        ['John Smith', 'Stanford', 'Chemistry', 'Jane Okoye', 'Ghent', '10', 'Belgium'],
        ['John Smith', 'Stanford', 'Chemistry', 'Patrick Hoch', 'Ghent', '10', 'Belgium'],
        ['John Smith', 'Stanford', 'Chemistry', 'Peter Smith', 'Brussels U; Ghent', '10', 'Belgium'],
        ['John Smith', 'Stanford', 'Chemistry', 'Dude without a country', 'Stanford', '1', '']
      ]
    end
  end

  context 'when limiting by year' do
    let(:organization) do
      Organization.create!(uri: 'http://example.com/department1',
                           name: 'Chemistry',
                           type: Organization::DEPARTMENT)
    end

    let(:start_year) { '2017' }

    let(:end_year) { '2017' }

    it 'is a report' do
      expect(CSV.parse(report)).to eq [
        ['Author', 'Institution', 'Department', 'Co-Author', 'Co-Author Institution',
         'Number of Collaborations', 'Co-Author Country'],
        ['John Smith', 'Stanford', 'Chemistry', 'Jane Okoye', 'Ghent', '10', 'Belgium'],
        ['John Smith', 'Stanford', 'Chemistry', 'Patrick Hoch', 'Ghent', '10', 'Belgium']
      ]
    end
  end

  context 'when querying by school' do
    let(:organization) do
      Organization.create!(uri: 'http://example.com/school1',
                           name: 'Biz School',
                           type: Organization::SCHOOL)
    end

    before do
      Organization.create!(uri: 'http://example.com/department1',
                           name: 'Chemistry')
    end

    it 'is a report' do
      expect(CSV.parse(report)).to eq [
        ['Author', 'Institution', 'Department', 'Co-Author', 'Co-Author Institution',
         'Number of Collaborations', 'Co-Author Country'],
        ['John Smith', 'Stanford', 'Chemistry', 'Jane Smith', 'Harvard', '1', 'United States'],
        ['John Smith', 'Stanford', 'Chemistry', 'Jane Okoye', 'Ghent', '10', 'Belgium'],
        ['John Smith', 'Stanford', 'Chemistry', 'Patrick Hoch', 'Ghent', '10', 'Belgium'],
        ['John Smith', 'Stanford', 'Chemistry', 'Peter Smith', 'Brussels U; Ghent', '10', 'Belgium'],
        ['John Smith', 'Stanford', 'Chemistry', 'Dude without a country', 'Stanford', '1', '']
      ]
    end
  end
end
