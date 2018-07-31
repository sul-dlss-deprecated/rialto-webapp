# frozen_string_literal: true

# Represents a university, school, divisition or department
class Organization < ApplicationRecord
  store_accessor :metadata, :name
end
