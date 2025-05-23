class AddAdminToUsers < ActiveRecord::Migration[8.0]
  def change
    #          table, collumn, data_type, default_value
    add_column :users, :admin, :boolean, default: false
  end
end
