# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'routes for the catalog', type: :routing do
  it 'accepts routes with slashes in the id parameter' do
    expect(get: '/catalog/http://scholars.cornell.edu/individual/UR-6717-4').to route_to(
      controller: 'catalog',
      action: 'show',
      id: 'http://scholars.cornell.edu/individual/UR-6717-4'
    )
  end
end
