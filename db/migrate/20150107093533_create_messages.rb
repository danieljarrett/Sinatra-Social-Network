class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.references :author
      t.references :conversation
      t.text :body
      t.timestamps
    end
  end
end