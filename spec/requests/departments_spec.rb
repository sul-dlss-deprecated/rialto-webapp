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

  let(:json) { JSON.parse(response.body) }
  let(:returned_labels) { json.map { |d| d['label'] } }

  it 'returns a report' do
    get '/departments.json'
    expect(returned_labels).to eq(['Biochemistry', 'Computer Science', 'Informatics'])
    expect(response.content_type).to eq 'application/json'
  end
end
