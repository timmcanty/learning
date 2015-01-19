class CreateTracks < ActiveRecord::Migration
  def change
    create_table :tracks do |t|
      t.string :title, null: false
      t.text :lyrics
      t.integer :album_id
      t.string :track_type, null: false
      t.timestamps
    end

    add_index :tracks, :album_id
  end
end
