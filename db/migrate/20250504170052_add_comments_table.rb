class AddCommentsTable < ActiveRecord::Migration[8.0]
  def change
    create_table :comments do |t|
      t.integer :user_id
      t.integer :post_id
      t.string :comment
      t.string :ancestry, null: false
      t.index :ancestry
      t.index [ "post_id" ], name: "index_comments_on_post_id"
      t.timestamps
    end
  end
end
