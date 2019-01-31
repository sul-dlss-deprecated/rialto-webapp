# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ResearchTrendsReportGenerator do
  subject(:report) do
    output = +''
    described_class.generate(output, org_uri: organization_uri, start_year: 2015, end_year: 2019)
    output
  end

  let(:organization_uri) { organization&.uri }

  before do
    # Create people
    p1 = Person.create!(uri: 'http://example.com/person1',
                        name: 'John Smith',
                        metadata: {
                          departments: ['http://example.com/department1'],
                          schools: ['http://example.com/school1']
                        })
    p2 = Person.create!(uri: 'http://example.com/person2',
                        name: 'Jane Smith',
                        metadata: {
                          departments: ['http://example.com/department1'],
                          schools: ['http://example.com/school1']
                        })
    p3 = Person.create!(uri: 'http://example.com/person3',
                        name: 'Jane Okoye',
                        metadata: {
                          departments: ['http://example.com/department2'],
                          schools: ['http://example.com/school2']
                        })

    Concept.create!(uri: 'http://example.com/concept1',
                    name: 'Concept1')

    Concept.create!(uri: 'http://example.com/concept2',
                    name: 'Concept2')

    Publication.create!(uri: 'http://example.com/publication1',
                        metadata: {
                          concepts: ['http://example.com/concept1'],
                          created_year: 2015
                        },
                        authors: [p1])
    Publication.create!(uri: 'http://example.com/publication2',
                        metadata: {
                          concepts: ['http://example.com/concept1'],
                          created_year: 2018
                        },
                        authors: [p1, p2, p3])
    Publication.create!(uri: 'http://example.com/publication3',
                        metadata: {
                          concepts: ['http://example.com/concept1'],
                          created_year: 2015
                        },
                        authors: [p2])
    Publication.create!(uri: 'http://example.com/publication4',
                        metadata: {
                          concepts: ['http://example.com/concept1'],
                          created_year: 2015
                        },
                        authors: [p3])
    Publication.create!(uri: 'http://example.com/publication5',
                        metadata: {
                          concepts: ['http://example.com/concept2'],
                          created_year: 2017
                        },
                        authors: [p2])
    # No concepts
    Publication.create!(uri: 'http://example.com/publication6',
                        metadata: {
                          concepts: [],
                          created_year: 2015
                        },
                        authors: [p1])
  end

  context 'when querying by department' do
    let(:organization) do
      Organization.create!(uri: 'http://example.com/department1',
                           name: 'Chemistry',
                           type: Organization::DEPARTMENT)
    end

    it 'is a report' do
      # rubocop:disable Style/WordArray
      puts(report)
      expect(CSV.parse(report)).to eq [
        ['Concept', '2015', '2016', '2017', '2018', '2019', 'Total'],
        ['Concept1', '2', '0', '0', '1', '0', '3'],
        ['Concept2', '0', '0', '1', '0', '0', '1'],
        ['No concept', '1', '0', '0', '0', '0', '1'],
        ['TOTAL', '3', '0', '1', '1', '0', '5']
      ]
      # rubocop:enable Style/WordArray
    end
  end

  context 'when querying by school' do
    let(:organization) do
      Organization.create!(uri: 'http://example.com/school1',
                           name: 'Chemistry',
                           type: Organization::SCHOOL)
    end

    it 'is a report' do
      # rubocop:disable Style/WordArray
      expect(CSV.parse(report)).to eq [
        ['Concept', '2015', '2016', '2017', '2018', '2019', 'Total'],
        ['Concept1', '2', '0', '0', '1', '0', '3'],
        ['Concept2', '0', '0', '1', '0', '0', '1'],
        ['No concept', '1', '0', '0', '0', '0', '1'],
        ['TOTAL', '3', '0', '1', '1', '0', '5']
      ]
      # rubocop:enable Style/WordArray
    end

    context 'when date range is specified' do
      subject(:report) do
        output = +''
        described_class.generate(output, org_uri: organization.uri, start_year: 2017, end_year: 2018)
        output
      end

      it 'is a report' do
        # rubocop:disable Style/WordArray
        expect(CSV.parse(report)).to eq [
          ['Concept', '2017', '2018', 'Total'],
          ['Concept1', '0', '1', '1'],
          ['Concept2', '1', '0', '1'],
          ['TOTAL', '1', '1', '2']
        ]
        # rubocop:enable Style/WordArray
      end
    end
  end

  context 'when all Stanford' do
    let(:organization) { nil }

    it 'is a report' do
      # rubocop:disable Style/WordArray
      puts(report)
      expect(CSV.parse(report)).to eq [
        ['Concept', '2015', '2016', '2017', '2018', '2019', 'Total'],
        ['Concept1', '3', '0', '0', '1', '0', '4'],
        ['Concept2', '0', '0', '1', '0', '0', '1'],
        ['No concept', '1', '0', '0', '0', '0', '1'],
        ['TOTAL', '4', '0', '1', '1', '0', '6']
      ]
      # rubocop:enable Style/WordArray
    end
  end
end
