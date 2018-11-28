# frozen_string_literal: true

require 'csv'

# Generate a downloadable report
# @abstract
class ReportGenerator
  # @param params [ActionController::Parameters]
  def self.generate(params)
    new(params.to_h.symbolize_keys).generate
  end

  # @param params [ActionController::Parameters]
  def self.count(params)
    new(params.to_h.symbolize_keys).count
  end
end
