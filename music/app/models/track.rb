class Track < ActiveRecord::Base
  TRACK_TYPES = ["Bonus", "Regular"]

  validates :title, :album_id, presence: true
  validate :correct_track_type

  has_many :notes

  private

  def correct_track_type
    unless TRACK_TYPES.include?(self.track_type)
      errors[:track_type] << "Invalid track type!"
    end
  end
end
