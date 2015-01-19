class CreateSubs < ActiveRecord::Migration
  def change
    create_table :subs do |t|
      t.string :title, null: false, unique: true
      t.text :description
      t.integer :user_id, null: false

      t.timestamps
    end

    add_index :subs, :user_id
  end
end
