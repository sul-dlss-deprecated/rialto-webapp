# frozen_string_literal: true

# Represents a publication
class Publication < ApplicationRecord
  has_and_belongs_to_many :authors, class_name: 'Person'
end
