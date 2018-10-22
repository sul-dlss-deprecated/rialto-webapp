# frozen_string_literal: true

class CreatePeoplePublicationsJoinTable < ActiveRecord::Migration[5.2]
  def change
    create_table :people_publications, id: false do |t|
      t.string :person_uri, null: false
      t.string :publication_uri, null: false
      t.index [:publication_uri, :person_uri], name: 'pub_person_uk', unique: true
    end
  end
end
