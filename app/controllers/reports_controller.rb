# frozen_string_literal: true

# Provides the various CSV reports
class ReportsController < ApplicationController
  def show
    generator = AuthorsCoauthorsReportGenerator

    respond_to do |format|
      format.csv { send_data generator.generate, type: Mime[:csv], disposition: 'attachment; filename=report.csv' }
    end
  end
end
