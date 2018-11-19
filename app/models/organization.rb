# frozen_string_literal: true

# Represents a university, school, divisition or department
class Organization < ApplicationRecord
  DEPARTMENT = 'http://vivoweb.org/ontology/core#Department'
  DIVISION = 'http://vivoweb.org/ontology/core#Division'
  INSTITUTE = 'http://vivoweb.org/ontology/core#Institute'
  SCHOOL = 'http://vivoweb.org/ontology/core#School'
  UNIVERSITY = 'http://vivoweb.org/ontology/core#University'
  store_accessor :metadata, :type, :parent_school
  scope :schools, -> { where("metadata->>'type' = ?", SCHOOL).order('name') }
  def self.departments(parent_school: nil)
    scope = where("metadata->>'type' = ?", DEPARTMENT)
    scope = scope.where("metadata->>'parent_school' = ?", parent_school) if parent_school
    scope.order('name')
  end
end
