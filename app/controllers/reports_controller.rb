# frozen_string_literal: true

# Provides the various CSV reports
class ReportsController < ApplicationController
  def show
    data = generator.generate(params.slice(:department_uri))

    respond_to do |format|
      format.csv do
        send_data data, type: Mime[:csv], disposition: 'attachment; filename=report.csv'
      end
    end
  end

  private

  def generator
    case params[:id]
    when 'coauthors'
      AuthorsCoauthorsReportGenerator
    when 'choropleth'
      ChoroplethReportGenerator
    else
      raise ActionController::RoutingError, 'Report type not Found'
    end
  end
end
