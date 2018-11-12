# frozen_string_literal: true

require 'rails_helper'

RSpec.describe GrantSearchBuilder do
  let(:config) { CatalogController.blacklight_config }
  let(:scope) { nil }
  let(:builder) { described_class.new(scope).with(params) }

  describe '#query' do
    subject(:solr_params) { builder.query }

    context 'when pi is provided' do
      let(:params) { { pi: '123abc' } }

      it 'filters for id and type' do
        expect(solr_params[:fq]).to eq ['pi_ssim:"123abc"', 'type_ssi:Grant']
        expect(solr_params[:rows]).to eq 1000
      end
    end
  end
end
