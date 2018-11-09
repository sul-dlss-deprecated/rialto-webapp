# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PublicationSearchBuilder do
  let(:config) { CatalogController.blacklight_config }
  let(:scope) { nil }
  let(:builder) { described_class.new(scope).with(params) }

  describe '#query' do
    subject(:solr_params) { builder.query }

    context 'when author is provided' do
      let(:params) { { author: '123abc' } }

      it 'filters for id and type' do
        expect(solr_params[:fq]).to eq ['authors_ssim:"123abc"', 'type_ssi:Publication']
        expect(solr_params[:rows]).to eq 1000
        expect(solr_params[:sort]).to eq 'created_year_isim desc'
      end
    end

    context 'when grant is provided' do
      let(:params) { { grant: '123abc' } }

      it 'filters for id and type' do
        expect(solr_params[:fq]).to eq ['grants_ssim:"123abc"', 'type_ssi:Publication']
        expect(solr_params[:rows]).to eq 1000
        expect(solr_params[:sort]).to eq 'created_year_isim desc'
      end
    end
  end
end
