# frozen_string_literal: true

class CreateConcept < ActiveRecord::Migration[5.2]
  def change
    create_table :concepts, id: :string, primary_key: :uri do |t|
      t.jsonb :metadata, null: false, default: {}
      t.string :name, null: false
      t.timestamps
    end
  end
end
