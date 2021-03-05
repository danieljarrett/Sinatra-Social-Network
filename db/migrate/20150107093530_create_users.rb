class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :username
      t.string :password_digest
      t.string :first_name
      t.string :last_name
      t.string :gender
      t.string :hometown
      t.string :current_city
      t.date :dob
      t.text :bio
      t.string :phone
      t.string :email
      t.timestamps
    end
  end
end