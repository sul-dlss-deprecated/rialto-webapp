# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SolrDocument do
  let(:doc) { described_class.new(data) }

  describe '#linked_authors' do
    subject(:authors) { doc.linked_authors }

    context 'when the record has authors' do
      let(:data) do
        {
          id: 'http://sul.stanford.edu/rialto/publications/7fec3f81bdf190e3e04d593c99803293',
          type_ssi: 'Publication',
          author_labels_tsim: ['Vohs, Kathleen D.',
                               'Baumeister, Roy F.'],
          authors_ssim: ['http://sul.stanford.edu/rialto/agents/people/a8ab23cc-9bdc-46b0-a69e-03661725219f',
                         'http://sul.stanford.edu/rialto/agents/people/17930ba1-ecde-4751-a444-c2995d9bcdbf']
        }
      end

      it 'returns HTML' do
        expect(authors).to eq(
          '<a href="/#/catalog/http%3A%2F%2Fsul.stanford.edu%2Frialto%2Fagents%2Fpeople%2Fa8ab23cc-9bdc-46b0-a69e-03661725219f">' \
          'Vohs, Kathleen D.</a> and ' \
          '<a href="/#/catalog/http%3A%2F%2Fsul.stanford.edu%2Frialto%2Fagents%2Fpeople%2F17930ba1-ecde-4751-a444-c2995d9bcdbf">' \
          'Baumeister, Roy F.</a>'
        )
        expect(authors).to be_html_safe
      end
    end

    context 'when the record has no authors' do
      let(:data) do
        {
          id: 'http://sul.stanford.edu/rialto/publications/7fec3f81bdf190e3e04d593c99803293',
          type_ssi: 'Publication'
        }
      end

      it 'returns an empty string' do
        expect(authors).to be_empty
      end
    end
  end
end
