# frozen_string_literal: true

class CreatePublications < ActiveRecord::Migration[5.2]
  def change
    create_table :publications do |t|
      t.string :uri, null: false
      t.jsonb :metadata, null: false, default: {}

      t.timestamps
    end
    add_index :publications, :uri, unique: true
  end
end
