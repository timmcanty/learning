class User < ActiveRecord::Base
  validates :username, :email, presence: true, uniqueness: true
  validates :password, length: { minimum: 6, allow_nil: true }

  after_initialize :ensure_session_token

  attr_reader :password

  has_many(
    :posts,
    class_name: "Post",
    foreign_key: :author_id,
    primary_key: :id
  )

  has_many(
    :comments,
    class_name: "Comment",
    foreign_key: :author_id,
    primary_key: :id
  )

  def self.generate_session_token
    SecureRandom.urlsafe_base64(16)
  end


  def ensure_session_token
    self.session_token ||= self.class.generate_session_token
  end

  def reset_session_token!
    new_token = User.generate_session_token
    if new_token != self.session_token
      self.session_token = new_token
    else
      self.reset_session_token!
    end
  end

  def password=(password)
    self.password_digest = BCrypt::Password.create(password)
  end

  def is_password?(password)
    BCrypt::Password.new(self.password_digest).is_password?(password)
  end

end
