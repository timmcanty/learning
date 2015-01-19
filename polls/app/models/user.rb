class User < ActiveRecord::Base
  validates :user_name, presence: true, uniqueness: true

  has_many(
    :authored_polls,
    class_name: "Poll",
    foreign_key: :author_id,
    primary_key: :id,
    dependent: :destroy
  )

  has_many(
    :responses,
    class_name: "Response",
    foreign_key: :responder_user_id,
    primary_key: :id,
    dependent: :destroy
  )

  def completed_polls
    responses = Response.where("responses.responder_user_id = ?", id)

    Poll
      .joins(:questions => :answer_choices)
      .joins("LEFT OUTER JOIN (#{responses.to_sql}) AS user_responses ON answer_choices.id = user_responses.answer_choice_id")
      .group("polls.id")
      .having("COUNT(DISTINCT questions.id) = COUNT(user_responses.id)")

  end

end
