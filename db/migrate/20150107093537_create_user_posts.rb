class CreateUserPosts < ActiveRecord::Migration
  def change
    create_table :user_posts do |t|
    	t.references :liker
    	t.references :post
      t.timestamps
    end
  end
end