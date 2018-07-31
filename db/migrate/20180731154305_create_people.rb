# frozen_string_literal: true

class CreatePeople < ActiveRecord::Migration[5.2]
  def change
    create_table :people do |t|
      t.string :uri, null: false
      t.jsonb :metadata, null: false, default: {}

      t.timestamps
    end
    add_index :people, :uri, unique: true
  end
end
