# frozen_string_literal: true

class CreatePeople < ActiveRecord::Migration[5.2]
  def change
    create_table :people, id: :string, primary_key: :uri do |t|
      t.jsonb :metadata, null: false, default: {}

      t.timestamps
    end
  end
end
