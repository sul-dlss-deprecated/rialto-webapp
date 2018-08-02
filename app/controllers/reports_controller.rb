# frozen_string_literal: true

# Provides the various CSV reports
class ReportsController < ApplicationController
  def show
    generator = AuthorsCoauthorsReportGenerator
    data = generator.generate(params[:id])

    respond_to do |format|
      format.csv do
        send_data data, type: Mime[:csv], disposition: 'attachment; filename=report.csv'
      end
    end
  end
end
