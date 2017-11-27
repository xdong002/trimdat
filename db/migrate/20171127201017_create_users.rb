class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
      t.string :email
      t.string :user_name
      t.string :password_digest
      t.binary :icon

      t.timestamps
    end
  end
end
