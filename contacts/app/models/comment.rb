class Comment < ActiveRecord::Base
  validates :body, presence: true
  validates :author, presence: true
  validates :commentable_type, presence: true
  validates :commentable_id, presence: true

  belongs_to :commentable, polymorphic:true

end
