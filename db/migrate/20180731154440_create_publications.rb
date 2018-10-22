# frozen_string_literal: true

class CreatePublications < ActiveRecord::Migration[5.2]
  def change
    create_table :publications, id: :string, primary_key: :uri do |t|
      t.jsonb :metadata, null: false, default: {}

      t.timestamps
    end
  end
end
