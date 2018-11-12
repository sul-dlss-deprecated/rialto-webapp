# frozen_string_literal: true

# Searches for grants
class GrantSearchBuilder < ::SearchBuilder
  self.default_processor_chain = [:linked_grants]

  def linked_grants(solr_parameters)
    solr_parameters[:fq] ||= []
    solr_parameters[:fq] += [type_filter]
    solr_parameters[:fq] += ['type_ssi:Grant']
    solr_parameters[:rows] = 1000
  end

  private

  def type_filter
    return "pi_ssim:\"#{blacklight_params.fetch(:pi)}\"" if blacklight_params.key?(:pi)
    raise ArgumentError, "No valid parameters were provided: #{params}"
  end
end
