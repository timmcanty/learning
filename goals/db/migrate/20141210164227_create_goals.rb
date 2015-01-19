class CreateGoals < ActiveRecord::Migration
  def change
    create_table :goals do |t|
      t.integer :author_id, null: FALSE
      t.string :content, null: FALSE
      t.boolean :public, default: FALSE
      t.boolean :complete, default: FALSE



      t.timestamps
    end

    add_index :goals, :author_id
  end
end
