# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Catalog', type: :request do
  let(:json) { JSON.parse(response.body) }
  let(:item) { json['data'] }
  let(:authors) { item['attributes']['authors']['attributes']['value'] }
  let(:doc) do
    {
      id: 'http://sul.stanford.edu/rialto/publications/7fec3f81bdf190e3e04d593c99803293',
      type_ssi: 'Publication',
      author_labels_tsim: ['Vohs, Kathleen D.',
                           'Baumeister, Roy F.'],
      authors_ssim: ['http://sul.stanford.edu/rialto/agents/people/a8ab23cc-9bdc-46b0-a69e-03661725219f',
                     'http://sul.stanford.edu/rialto/agents/people/17930ba1-ecde-4751-a444-c2995d9bcdbf']
    }
  end

  before do
    conn = Blacklight.default_index.connection
    conn.add [doc]
    conn.commit
  end

  describe 'show' do
    it 'returns a report' do
      headers = { 'ACCEPT' => 'application/json' }
      get '/catalog/http%3A%2F%2Fsul.stanford.edu%2Frialto%2Fpublications%2F7fec3f81bdf190e3e04d593c99803293', headers: headers
      expect(item['type']).to eq 'Publication'
      expect(authors).to eq(
        '<a href="/#/item/http%3A%2F%2Fsul.stanford.edu%2Frialto%2Fagents%2Fpeople%2Fa8ab23cc-9bdc-46b0-a69e-03661725219f">' \
        'Vohs, Kathleen D.</a> and ' \
        '<a href="/#/item/http%3A%2F%2Fsul.stanford.edu%2Frialto%2Fagents%2Fpeople%2F17930ba1-ecde-4751-a444-c2995d9bcdbf">' \
        'Baumeister, Roy F.</a>'
      )
    end
  end
end
