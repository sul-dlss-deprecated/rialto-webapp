# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'CSV reports', type: :request do
  let(:csv) do
    CSV.generate { |doc| doc << %w[Foo Bar] }
  end

  before do
    allow(AuthorsCoauthorsReportGenerator).to receive(:generate).and_return(csv)
  end

  it 'returns a report' do
    get '/reports/report.csv'
    expect(response.body).to eq "Foo,Bar\n"
    expect(response.content_type).to eq 'text/csv'
  end
end
