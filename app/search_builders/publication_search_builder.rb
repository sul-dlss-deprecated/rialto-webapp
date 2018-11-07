# frozen_string_literal: true

# Searches for publications
class PublicationSearchBuilder < ::SearchBuilder
  self.default_processor_chain = [:linked_publications]

  def linked_publications(solr_parameters)
    solr_parameters[:fq] ||= []
    solr_parameters[:fq] += ["authors_ssim:\"#{author}\""]
    solr_parameters[:fq] += ['type_ssi:Publication']
    solr_parameters[:rows] = 1000
  end

  private

  def author
    blacklight_params.fetch(:author)
  end
end
