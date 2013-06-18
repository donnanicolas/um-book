class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.text :content
      t.integer :user_a_id
      t.integer :user_b_id

      t.timestamps
    end
  end
end
