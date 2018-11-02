# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'CSV reports', type: :request do
  let(:csv) do
    CSV.generate { |doc| doc << %w[Foo Bar] }
  end

  context 'when the coauthors report is requested' do
    before do
      allow(AuthorsCoauthorsReportGenerator).to receive(:generate).and_return(csv)
    end

    it 'returns CSV data' do
      get '/reports/coauthors.csv?org_uri=7'
      expect(response.body).to eq "Foo,Bar\n"
      expect(response.content_type).to eq 'text/csv'
      expect(AuthorsCoauthorsReportGenerator).to have_received(:generate)
        .with(ActionController::Parameters.new(org_uri: '7'))
    end
  end
end
