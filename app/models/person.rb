# frozen_string_literal: true

# Represents an author of a publication
class Person < ApplicationRecord
  has_and_belongs_to_many :publications
  store_accessor :metadata, :name, :institutionalAffiliation, :department

  delegate :name, to: :institution_entity, prefix: :institution

  def institution_entity
    @institution_entity ||= Organization.find_by(uri: institutionalAffiliation)
  end

  delegate :name, to: :department_entity, prefix: :department

  def department_entity
    @department_entity ||= Organization.find_by(uri: department)
  end
end
