class Band < ActiveRecord::Base
  validates :name, uniqueness: true, presence: true

  has_many :albums, dependent: :destroy

end
