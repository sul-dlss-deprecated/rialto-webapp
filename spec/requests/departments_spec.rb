# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Deparment list', type: :request do
  before do
    # The results should not include this organization because it's a university:
    Organization.create!(uri: 'http://example.com/institution1',
                         metadata: {
                           name: 'Stanford',
                           type: 'http://vivoweb.org/ontology/core#University'
                         })

    Organization.create!(uri: 'http://example.com/department2',
                         metadata: {
                           name: 'Biochemistry',
                           type: Organization::DEPARTMENT
                         })

    Organization.create!(uri: 'http://example.com/department3',
                         metadata: {
                           name: 'Informatics',
                           type: Organization::DEPARTMENT
                         })

    Organization.create!(uri: 'http://example.com/department4',
                         metadata: {
                           name: 'Computer Science',
                           type: Organization::DEPARTMENT
                         })
  end

  it 'returns a report' do
    get '/departments.json'
    json = JSON.parse(response.body)
    expect(json.size).to eq 3
    expect(json).to all(include('id', 'label'))
    expect(response.content_type).to eq 'application/json'
  end
end
