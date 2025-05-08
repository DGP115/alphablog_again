class AddDepthCacheToComments < ActiveRecord::Migration[8.0]
  def change
    add_column :comments, :ancestry_depth, :integer, default: 0
    add_column :comments, :children_count, :integer, default: 0, null: false
  end
end
