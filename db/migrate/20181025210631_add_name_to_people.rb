# frozen_string_literal: true

class AddNameToPeople < ActiveRecord::Migration[5.2]
  def change
    add_column :people, :name, :string
  end
end
