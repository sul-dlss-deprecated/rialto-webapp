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
      get '/reports/coauthors.csv?department_uri=7'
      expect(response.body).to eq "Foo,Bar\n"
      expect(response.content_type).to eq 'text/csv'
      expect(AuthorsCoauthorsReportGenerator).to have_received(:generate)
        .with(ActionController::Parameters.new(department_uri: '7'))
    end
  end

  context 'when the choropleth report is requested' do
    before do
      allow(ChoroplethReportGenerator).to receive(:generate).and_return(csv)
    end

    it 'returns a report for driving the choropleth visualization' do
      get '/reports/choropleth.csv?department_uri=7'
      expect(response.body).to eq "Foo,Bar\n"
      expect(response.content_type).to eq 'text/csv'
      expect(ChoroplethReportGenerator).to have_received(:generate)
        .with(ActionController::Parameters.new(department_uri: '7'))
    end
  end
end
