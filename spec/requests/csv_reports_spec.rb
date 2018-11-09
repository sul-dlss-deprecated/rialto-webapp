# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'CSV reports', type: :request do
  before do
    Organization.create!(uri: 'http://example.com/institution1',
                         name: 'Stanford')
  end

  context 'when the coauthors report is requested' do
    it 'returns CSV data' do
      get '/reports/coauthors.csv?org_uri=http://example.com/institution1&start_year=2005&end_year=2015'
      expect(response.body).to eq "Author,Institution,Department,Co-Author,Co-Author Institution,Number of Collaborations,Co-Author Country\n"
      expect(response.content_type).to eq 'text/csv'
    end
  end
end
