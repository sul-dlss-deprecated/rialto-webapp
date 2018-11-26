# frozen_string_literal: true

class AddIndexes < ActiveRecord::Migration[5.2]
  def change
    enable_extension 'btree_gin'
    add_index :people, "(metadata->>'departments')", using: 'GIN'
    add_index :people, "(metadata->>'schools')", using: 'GIN'
    add_index :publications, "(metadata->>'concepts')", using: 'GIN'
    add_index :publications, "((metadata ->> 'created_year')::numeric)", using: 'BTREE'
    add_index :people, :name
    add_index :organizations, :name
  end
end
