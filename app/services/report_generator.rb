# frozen_string_literal: true

require 'csv'

# Generate a downloadable report
# @abstract
class ReportGenerator
  # @param output [Enumerator]
  # @param params [ActionController::Parameters]
  def self.generate(output, params)
    new(output, params.to_h.symbolize_keys).generate
  end

  # @param params [ActionController::Parameters]
  def self.count(output, params)
    new(output, params.to_h.symbolize_keys).count
  end

  # @param params [ActionController::Parameters]
  def self.details(output, params)
    new(output, params.to_h.symbolize_keys).details
  end
end
