# frozen_string_literal: true

# Searches for publications
class PublicationSearchBuilder < ::SearchBuilder
  self.default_processor_chain = [:linked_publications]

  def linked_publications(solr_parameters)
    solr_parameters[:fq] ||= []
    solr_parameters[:fq] += [type_filter]
    solr_parameters[:fq] += ['type_ssi:Publication']
    solr_parameters[:rows] = 1000
  end

  private

  def type_filter
    return "authors_ssim:\"#{blacklight_params.fetch(:author)}\"" if blacklight_params.key?(:author)
    return "grants_ssim:\"#{blacklight_params.fetch(:grant)}\"" if blacklight_params.key?(:grant)
    raise ArgumentError, "No valid parameters were provided: #{params}"
  end
end
