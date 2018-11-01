# frozen_string_literal: true

# Represents a publication
class Publication < ApplicationRecord
  has_and_belongs_to_many :authors, class_name: 'Person', foreign_key: 'publication_uri', association_foreign_key: 'person_uri'
  store_accessor :metadata, :concepts

  def concept_entities
    @concept_entities ||= Concept.where(uri: concepts)
  end
end
