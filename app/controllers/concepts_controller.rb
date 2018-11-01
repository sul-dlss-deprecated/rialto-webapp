# frozen_string_literal: true

# Provides a list of concepts
class ConceptsController < ApplicationController
  def index
    @concepts = Concept.order(:name)

    respond_to do |format|
      format.json {}
    end
  end
end
