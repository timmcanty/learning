class User < ActiveRecord::Base

  validates :user_name,  presence: true
  validates :session_token, :user_name, uniqueness: true

  has_many :cats

  has_many :users

  has_many :sessions,
    class_name: "UserSession",
    foreign_key: :user_id,
    primary_key: :id

  def self.find_by_credentials(user_name, password)
    user = User.find_by_user_name(user_name)
    return nil if user.nil? || !user.is_password?(password)
    user
  end

  def random_session_token
    SecureRandom.urlsafe_base64
  end

  def password=(password)
    self.password_digest = BCrypt::Password.create(password)
  end

  def is_password?(password)
    password_hash = BCrypt::Password.new(self.password_digest)
    password_hash.is_password?(password)
  end
end
