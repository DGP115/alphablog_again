class AddUserRole < ActiveRecord::Migration[8.0]
  def change
    remove_column :users, :admin, :boolean
    add_column :users, :role, :string
  end
end
# This migration removes the `admin` column from the `users` table and adds a new `role` column.
