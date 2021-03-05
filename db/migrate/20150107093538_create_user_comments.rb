class CreateUserComments < ActiveRecord::Migration
  def change
    create_table :user_comments do |t|
    	t.references :liker
    	t.references :comment
      t.timestamps
    end
  end
end