# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'routes for the reports', type: :routing do
  it 'routes to the coauthors report' do
    expect(get: '/catalog/coauthors?department_id=7').to route_to(
      controller: 'catalog',
      action: 'show',
      id: 'coauthors',
      department_id: '7'
    )
  end
end
