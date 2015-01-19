class Post < ActiveRecord::Base
  validates :title, presence: true, uniqueness: true
  validates :author_id, presence: true

  belongs_to(
    :author,
    class_name: "User",
    foreign_key: :author_id,
    primary_key: :id
  )


  has_many :comments

  has_many :post_subs, inverse_of: :post

  has_many :subs, through: :post_subs, source: :sub

  def comments_by_parent_id
    results = Hash.new { |hash,key|  hash[key] = [] }
    self.comments.includes(:author).each do |comment|
      results[comment.parent_comment_id] << comment
    end

    results
  end
end
