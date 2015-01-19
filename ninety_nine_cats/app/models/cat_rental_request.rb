class CatRentalRequest < ActiveRecord::Base
  VALID_STATUSES = ["PENDING","APPROVED","DENIED"]

  validates :cat_id, :start_date, :end_date, :status, :user_id, presence: true
  validate :valid_status
  validate :overlapping_approved_requests

  after_initialize do
    self.status ||= "PENDING"
  end

  belongs_to :cat

  belongs_to :user

  def approve
    begin
      self.approve!
      return true
    rescue
      return false
    end
  end

  def approve!
    CatRentalRequest.transaction do
      self.status = "APPROVED"
      self.save!
      overlapping_pending_requests.each do |request|
        request.status = "DENIED"
        request.save!
      end
    end
  end

  def deny
    begin
      self.deny!
      return true
    rescue
      return false
    end
  end

  def deny!
    self.status = "DENIED"
    self.save!
  end

  private

  def valid_status
    unless VALID_STATUSES.include?(self.status)
      errors[:status] << "invalid status"
    end
  end

  def overlapping_requests
    CatRentalRequest
      .where(cat_id: self.cat_id)
      .where.not(id: self.id)
      .where.not("end_date < ? OR start_date > ?", self.start_date, self.end_date)
  end

  def overlapping_approved_requests
    if overlapping_requests.where(status: "APPROVED").exists? && self.status != "DENIED"
      errors[:status] << "there are overlapping approved requests"
    end
  end

  def overlapping_pending_requests
    overlapping_requests.where(status: "PENDING")
  end

end
