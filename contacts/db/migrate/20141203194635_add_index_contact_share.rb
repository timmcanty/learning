class AddIndexContactShare < ActiveRecord::Migration
  def change
    add_index :contact_shares, [:user_id, :contact_id], unique: true
  end
end
