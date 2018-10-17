# frozen_string_literal: true

# Represents an author of a publication
class Person < ApplicationRecord
  has_and_belongs_to_many :publications
  store_accessor :metadata, :name, :institutionalAffiliations, :departments

  def institution_entities
    @institution_entities ||= Organization.where(uri: institutionalAffiliations)
  end

  def department_entities
    @department_entities ||= Organization.where(uri: departments)
  end
end
