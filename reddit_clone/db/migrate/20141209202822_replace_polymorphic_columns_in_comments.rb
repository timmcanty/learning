class ReplacePolymorphicColumnsInComments < ActiveRecord::Migration
  def change
    remove_column :comments, :parentable_type
    remove_column :comments, :parentable_id
    add_column :comments, :parent_comment_id, :integer
  end
end
