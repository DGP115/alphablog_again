class AddUseridToPosts < ActiveRecord::Migration[8.0]
  def change
    add_column :posts, :user_id, :int
  end
end
