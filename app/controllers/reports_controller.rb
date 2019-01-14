# frozen_string_literal: true

# Provides the various CSV reports
class ReportsController < ApplicationController
  # rubocop:disable Metrics/MethodLength
  # rubocop:disable Metrics/AbcSize
  def show
    respond_to do |format|
      format.csv do
        add_headers
        self.response_body = Enumerator.new do |out|
          if params.key?(:count)
            generator.count(out, params.permit(:org_uri, :concept_uri, :start_year, :end_year))
          elsif params.key?(:details)
            generator.details(out, params.permit(:org_uri, :concept_uri, :start_year, :end_year, :country_label, :institution_label))
          else
            generator.generate(out, params.permit(:org_uri, :concept_uri, :start_year, :end_year, :offset, :limit))
          end
        end
      end
    end
  end
  # rubocop:enable Metrics/MethodLength
  # rubocop:enable Metrics/AbcSize

  private

  def add_headers
    headers['X-Accel-Buffering'] = 'no'
    headers['Cache-Control'] = 'no-cache'
    headers['Content-Type'] = 'text/csv; charset=utf-8'
    headers['Content-Disposition'] = %(attachment; filename="report.csv")
    headers['Last-Modified'] = Time.zone.now.ctime.to_s
  end

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

  def counter
    case params[:id]
    when 'coauthors'
      AuthorsCoauthorsReportGenerator
    else
      raise ActionController::RoutingError, 'Report type not Found'
    end
  end
end
