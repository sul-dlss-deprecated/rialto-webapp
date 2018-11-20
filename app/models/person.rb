# frozen_string_literal: true

# Represents an author of a publication
class Person < ApplicationRecord
  has_and_belongs_to_many :publications, foreign_key: 'person_uri', association_foreign_key: 'publication_uri'
  store_accessor :metadata, :institutions, :departments, :country_labels

  def institution_entities
    @institution_entities ||= Organization.where(uri: institutions)
  end

  def department_entities
    @department_entities ||= Organization.where(uri: departments)
  end

  # Returns the metadata field for the provided organization type or nil if no field.
  def self.org_metadata_field(org_type)
    case org_type
    when Organization::SCHOOL
      'schools'
    when Organization::DEPARTMENT
      'departments'
    when Organization::INSTITUTE
      'institutes'
    end
  end
end
