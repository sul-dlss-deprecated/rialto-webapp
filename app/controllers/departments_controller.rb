# frozen_string_literal: true

# Provides a list of departments
class DepartmentsController < ApplicationController
  def index
    @departments = Organization.departments

    respond_to do |format|
      format.json {}
    end
  end
end
