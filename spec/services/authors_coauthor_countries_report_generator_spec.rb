# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AuthorsCoauthorCountriesReportGenerator do
  let(:start_year) { '2016' }

  let(:end_year) { '2018' }

  let(:organization_uri) { organization&.uri }

  before do
    # Create people
    p1 = Person.create!(uri: 'http://example.com/person1',
                        name: 'John Smith',
                        metadata: {
                          departments: ['http://example.com/department1'],
                          schools: ['http://example.com/school1'],
                          country_labels: ['United States']
                        })
    p2 = Person.create!(uri: 'http://example.com/person2',
                        name: 'Jane Smith',
                        metadata: {
                          departments: ['http://example.com/department1'],
                          schools: ['http://example.com/school1'],
                          country_labels: ['United States']
                        })
    p3 = Person.create!(uri: 'http://example.com/person3',
                        name: 'Jane Okoye',
                        metadata: {
                          country_labels: ['Belgium']
                        })
    p4 = Person.create!(uri: 'http://example.com/person4',
                        name: 'Patrick Hoch',
                        metadata: {
                          country_labels: ['Canada']
                        })
    p5 = Person.create!(uri: 'http://example.com/person5',
                        name: 'Patricia Koch',
                        metadata: {
                          country_labels: ['Canada']
                        })
    # In another department / school
    p6 = Person.create!(uri: 'http://example.com/person6',
                        name: 'Peter Smith',
                        metadata: {
                          departments: ['http://example.com/department2'],
                          schools: ['http://example.com/school2'],
                          country_labels: ['Croatia']
                        })
    # No country
    p7 = Person.create!(uri: 'http://example.com/person7',
                        name: 'Jane Lathrop',
                        metadata: {
                          country_labels: []
                        })

    # John Smith co-authored with Jane Okoye twice
    Publication.create!(uri: 'http://example.com/publication1',
                        metadata: {
                          created_year: 2018,
                          title: 'Publication1'
                        },
                        authors: [p1, p3])
    Publication.create!(uri: 'http://example.com/publication2',
                        metadata: {
                          created_year: 2016,
                          title: 'Publication2'
                        },
                        authors: [p1, p3])
    # John Smith co-authored with Patrick Hoch once
    Publication.create!(uri: 'http://example.com/publication3',
                        metadata: {
                          created_year: 2016,
                          title: 'Publication 3'
                        },
                        authors: [p1, p4])
    # John Smith co-authored with Jane and Patrick once
    Publication.create!(uri: 'http://example.com/publication4',
                        metadata: {
                          created_year: 2018,
                          title: 'Publication 4'
                        },
                        authors: [p1, p3, p4])
    # Jane Smith co-authored with Jane Okoye once
    Publication.create!(uri: 'http://example.com/publication5',
                        metadata: {
                          created_year: 2018,
                          title: 'Publication 5'
                        },
                        authors: [p2, p3])
    # Jane Smith co-authored with Patricia Koch once
    Publication.create!(uri: 'http://example.com/publication6',
                        metadata: {
                          created_year: 2018,
                          title: 'Publication 6'
                        },
                        authors: [p2, p5])
    # John Smith and Jane Smith co-authored once
    Publication.create!(uri: 'http://example.com/publication7',
                        metadata: {
                          created_year: 2018,
                          title: 'Publication 7'
                        },
                        authors: [p1, p2])
    # Jane Okoye co-authored with someone in another department
    # Jane Smith co-authored with Jane Okoye once
    Publication.create!(uri: 'http://example.com/publication8',
                        metadata: {
                          created_year: 2018,
                          title: 'Publication 8'
                        },
                        authors: [p6, p3])
    # Peter Smith co-autored with Jane Lathrop
    Publication.create!(uri: 'http://example.com/publication9',
                        metadata: {
                          created_year: 2018,
                          title: 'Publication 9'
                        },
                        authors: [p6, p7])
  end

  describe '#generate' do
    subject(:report) do
      output = +''
      described_class.generate(output, org_uri: organization_uri, start_year: start_year, end_year: end_year)
      output
    end

    context 'when querying by department' do
      let(:organization) do
        Organization.create!(uri: 'http://example.com/department1',
                             name: 'Chemistry',
                             type: Organization::DEPARTMENT)
      end

      it 'is a report' do
        # rubocop:disable Style/WordArray
        expect(CSV.parse(report)).to eq [
          ['Co-Author Country', 'Number of Collaborations'],
          ['Belgium', '4'],
          ['Canada', '3'],
          ['United States', '2']
        ]
        # rubocop:enable Style/WordArray
      end
    end

    context 'when limiting by years' do
      let(:organization) do
        Organization.create!(uri: 'http://example.com/department1',
                             name: 'Chemistry',
                             type: Organization::DEPARTMENT)
      end

      let(:start_year) { '2017' }

      it 'is a report' do
        # rubocop:disable Style/WordArray
        expect(CSV.parse(report)).to eq [
          ['Co-Author Country', 'Number of Collaborations'],
          ['Belgium', '3'],
          ['Canada', '2'],
          ['United States', '2']
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
          ['Co-Author Country', 'Number of Collaborations'],
          ['Belgium', '4'],
          ['Canada', '3'],
          ['United States', '2']
        ]
        # rubocop:enable Style/WordArray
      end
    end

    context 'when all Stanford' do
      let(:organization) { nil }

      it 'is a report' do
        # rubocop:disable Style/WordArray
        expect(CSV.parse(report)).to eq [
          ['Co-Author Country', 'Number of Collaborations'],
          ['Belgium', '5'],
          ['Canada', '3'],
          ['United States', '2'],
          ['Unknown', '1']
        ]
        # rubocop:enable Style/WordArray
      end
    end
  end

  describe '#details' do
    subject(:report) do
      output = +''
      described_class.details(output, org_uri: organization_uri, start_year: start_year, end_year: end_year, country_label: country_label)
      output
    end

    let(:country_label) { 'Canada' }

    context 'when all Stanford and details for a country' do
      let(:organization) { nil }

      it 'is a report' do
        expect(CSV.parse(report)).to eq [
          ['Collab Country', 'Collab Name', 'Name', 'Title', 'Year'],
          ['Canada', 'Patrick Hoch', 'John Smith', 'Publication 3', '2016'],
          ['Canada', 'Patrick Hoch', 'John Smith', 'Publication 4', '2018'],
          ['Canada', 'Patricia Koch', 'Jane Smith', 'Publication 6', '2018']
        ]
      end
    end
  end
end
