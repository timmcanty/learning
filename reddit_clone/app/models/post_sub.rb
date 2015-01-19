class PostSub < ActiveRecord::Base
  validates :post_id, :sub_id, presence: true
  validate :not_duplicate

  belongs_to :post, inverse_of: :post_subs
  belongs_to :sub, inverse_of: :post_subs

  private

  def not_duplicate
    post_subs = PostSub.all
    sub_posts = post_subs.map{ |postsub| [postsub.post_id,postsub.sub_id]}
    if sub_posts != sub_posts.uniq
      self.errors[:postsub] << "Non-unique post"
    end
  end


end
