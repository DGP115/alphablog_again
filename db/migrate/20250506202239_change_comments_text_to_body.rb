class ChangeCommentsTextToBody < ActiveRecord::Migration[8.0]
  def change
    add_column :comments, :body, :string
    remove_column :comments, :comment, :string
  end
end
