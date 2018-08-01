# frozen_string_literal: true

# Represents a university, school, divisition or department
class Organization < ApplicationRecord
  DEPARTMENT = 'http://vivoweb.org/ontology/core#Department'
  store_accessor :metadata, :name, :country
  scope :departments, -> { where("metadata->>'type' = ?", DEPARTMENT) }
end
