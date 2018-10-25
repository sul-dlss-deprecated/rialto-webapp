# frozen_string_literal: true

class AddNameToOrganization < ActiveRecord::Migration[5.2]
  def change
    add_column :organizations, :name, :string
  end
end
