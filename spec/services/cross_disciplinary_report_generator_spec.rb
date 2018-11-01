# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CrossDisciplinaryReportGenerator do
  subject(:report) { described_class.generate(concept_uri: concept.uri) }

  let(:concept) do
    Concept.create!(uri: 'http://example.com/concept1',
                    name: 'Philosophy')
  end

  context 'with some authors and publications' do
    before do
      Concept.create!(uri: 'http://example.com/concept2',
                      name: 'Information Science')

      # Create institutes
      Organization.create!(uri: 'http://example.com/institute1',
                           name: 'Wittgenstein Institute')

      Organization.create!(uri: 'http://example.com/institute2',
                           name: 'Metaphysics Institute')

      # Create people
      p1 = Person.create!(uri: 'http://example.com/person1',
                          name: 'John Smith',
                          metadata: {
                            institutes: ['http://example.com/institute1']
                          })
      p2 = Person.create!(uri: 'http://example.com/person2',
                          name: 'Jane Smith',
                          metadata: {
                            institutes: ['http://example.com/institute2']
                          })
      p3 = Person.create!(uri: 'http://example.com/person3',
                          name: 'Jane Okoye',
                          metadata: {
                            institutes: ['http://example.com/institute2']
                          })
      # Create publications
      # John Smith has 2 publications in 2016 and 1 in 2018
      # Note the extra concept for publication1
      Publication.create!(uri: 'http://example.com/publication1',
                          authors: [p1],
                          metadata: {
                            created_year: 2016,
                            concepts: ['http://example.com/concept1', 'http://example.com/concept2']
                          })
      Publication.create!(uri: 'http://example.com/publication2',
                          authors: [p1],
                          metadata: {
                            created_year: 2016,
                            concepts: ['http://example.com/concept1']
                          })
      Publication.create!(uri: 'http://example.com/publication3',
                          authors: [p1],
                          metadata: {
                            created_year: 2018,
                            concepts: ['http://example.com/concept1']
                          })
      # Jane Smith has 2 publications in 2017
      Publication.create!(uri: 'http://example.com/publication4',
                          authors: [p2],
                          metadata: {
                            created_year: 2017,
                            concepts: ['http://example.com/concept1']
                          })
      Publication.create!(uri: 'http://example.com/publication5',
                          authors: [p2],
                          metadata: {
                            created_year: 2017,
                            concepts: ['http://example.com/concept1']
                          })
      # Jane Okoye has 1 publication in 2016 and 1 in 2017
      Publication.create!(uri: 'http://example.com/publication6',
                          authors: [p3],
                          metadata: {
                            created_year: 2016,
                            concepts: ['http://example.com/concept1']
                          })
      Publication.create!(uri: 'http://example.com/publication7',
                          authors: [p3],
                          metadata: {
                            created_year: 2017,
                            concepts: ['http://example.com/concept1']
                          })
      # This publication is related to concept2
      Publication.create!(uri: 'http://example.com/publication8',
                          authors: [p3],
                          metadata: {
                            created_year: 2017,
                            concepts: ['http://example.com/concept2']
                          })
    end

    it 'is a report' do
      # rubocop:disable Style/WordArray
      expect(CSV.parse(report)).to eq [
        ['Institute', '2016', '2017', '2018'],
        ['Metaphysics Institute', '1', '3', '0'],
        ['Wittgenstein Institute', '2', '0', '1']
      ]
      # rubocop:enable Style/WordArray
    end
  end
end
