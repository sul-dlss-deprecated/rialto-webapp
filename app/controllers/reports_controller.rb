# frozen_string_literal: true

# Provides the various CSV reports
class ReportsController < ApplicationController
  def show
    data = generator.generate(params.permit(:org_uri, :concept_uri, :start_year, :end_year))

    respond_to do |format|
      format.csv do
        send_data data, type: Mime[:csv], disposition: 'attachment; filename=report.csv'
      end
    end
  end

  private

  # rubocop:disable Metrics/MethodLength
  # rubocop:disable Metrics/CyclomaticComplexity
  def generator
    case params[:id]
    when 'coauthors'
      AuthorsCoauthorsReportGenerator
    when 'coauthor-institutions'
      AuthorsCoauthorInstitutionsReportGenerator
    when 'coauthor-countries'
      AuthorsCoauthorCountriesReportGenerator
    when 'choropleth'
      ChoroplethReportGenerator
    when 'cross-disciplinary'
      CrossDisciplinaryReportGenerator
    when 'research-trends'
      ResearchTrendsReportGenerator
    else
      raise ActionController::RoutingError, 'Report type not Found'
    end
  end
  # rubocop:enable Metrics/MethodLength
  # rubocop:enable Metrics/CyclomaticComplexity
end
