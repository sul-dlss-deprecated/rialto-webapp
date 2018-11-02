# frozen_string_literal: true

# Represents a university, school, divisition or department
class Organization < ApplicationRecord
  DEPARTMENT = 'http://vivoweb.org/ontology/core#Department'
  DIVISION = 'http://vivoweb.org/ontology/core#Division'
  INSTITUTE = 'http://vivoweb.org/ontology/core#Institute'
  SCHOOL = 'http://vivoweb.org/ontology/core#School'
  UNIVERSITY = 'http://vivoweb.org/ontology/core#University'
  store_accessor :metadata, :type, :country
  scope :departments, -> { where("metadata->>'type' = ?", DEPARTMENT).order('name') }
  scope :schools, -> { where("metadata->>'type' = ?", SCHOOL).order('name') }
end
