require 'date'

class Cat < ActiveRecord::Base

  VALID_COLORS = ["grey", "brown", "black", "white", "orange"]

  validates :birth_date, :color, :name, :sex, :description, :user_id, presence: true
  # validates :color, inclusion: { in: VALID_COLORS }
  validate :check_for_valid_color
  validate :check_for_valid_sex

  belongs_to :owner,
    class_name: "User",
    foreign_key: :user_id,
    primary_key: :id

  has_many :rental_requests,
    class_name: "CatRentalRequest",
    foreign_key: :cat_id,
    dependent: :destroy,
    primary_key: :id

  def age
    today = Date::today
    birth_day = Date.parse(birth_date)
    ((today - birth_day)/365).to_i
  end

  def check_for_valid_sex
    unless sex == "M" || sex == "F"
      error[:sex] << "Invalid cat sex"
    end
  end

  def check_for_valid_color
    unless VALID_COLORS.include?(color)
      error[:color] << "Invalid cat color"
    end
  end


end
