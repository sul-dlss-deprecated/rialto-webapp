# frozen_string_literal: true

# Provides a list of departments
class SchoolsController < ApplicationController
  def index
    @schools = Organization.schools

    respond_to do |format|
      format.json {}
    end
  end
end
