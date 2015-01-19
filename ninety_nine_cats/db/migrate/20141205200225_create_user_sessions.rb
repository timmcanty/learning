class CreateUserSessions < ActiveRecord::Migration
  def change
    create_table :user_sessions do |t|
      t.integer :user_id
      t.string :session_token
      t.string :device
      t.string :browser
      t.string :location

      t.timestamps
    end
    add_index :user_sessions, :user_id
  end
end
