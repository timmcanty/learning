class Album < ActiveRecord::Base
  RECORDING_SETTINGS = ["Live","Studio"]
  validates :name, :band_id, presence:true
  validate :recording_setting_matches

  belongs_to :band

  has_many :tracks, dependent: :destroy



  private

  def recording_setting_matches #fix that
    unless RECORDING_SETTINGS.include?(recording_setting)
      errors[:recording_setting] << "Invalid recording setting!"
    end
  end
end
