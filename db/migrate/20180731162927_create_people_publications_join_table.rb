# frozen_string_literal: true

class CreatePeoplePublicationsJoinTable < ActiveRecord::Migration[5.2]
  def change
    create_join_table :people, :publications do |t|
      t.index :person_id
      t.index :publication_id
      t.index [:publication_id, :person_id], name: 'pub_person_uk', unique: true
    end
  end
end
