class CreateUserConversations < ActiveRecord::Migration
  def change
    create_table :user_conversations do |t|
    	t.references :participant
    	t.references :conversation
      t.timestamps
    end
  end
end