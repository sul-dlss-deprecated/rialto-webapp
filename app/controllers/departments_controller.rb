# frozen_string_literal: true

# Provides a list of departments
class DepartmentsController < ApplicationController
  def index
    # Note that parent_school may be nil.
    @departments = Organization.departments(parent_school: params['parent_school'])

    respond_to do |format|
      format.json {}
    end
  end
end
