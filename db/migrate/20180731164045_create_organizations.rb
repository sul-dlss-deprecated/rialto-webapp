# frozen_string_literal: true

class CreateOrganizations < ActiveRecord::Migration[5.2]
  def change
    create_table :organizations do |t|
      t.string :uri
      t.jsonb :metadata

      t.timestamps
    end
    add_index :organizations, :uri, unique: true
    add_index :organizations, "(metadata->>'department')", using: 'HASH'
    add_index :organizations, "(metadata->>'type')", using: 'HASH'
  end
end
