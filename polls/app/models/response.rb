class Response < ActiveRecord::Base

  validates :responder_user_id, presence: true
  validates :answer_choice_id, presence: true
  validate :respondent_has_not_already_answered_question
  validate :author_is_not_respondent

  belongs_to(
    :answer_choice,
    class_name: "AnswerChoice",
    foreign_key: :answer_choice_id,
    primary_key: :id
  )

  belongs_to(
    :responder,
    class_name: "User",
    foreign_key: :responder_user_id,
    primary_key: :id
  )

  has_one :question, through: :answer_choice, source: :question

private

  def sibling_responses
    Response
    .select("DISTINCT sibling_responses.*")
    .joins(:answer_choice => :question)
    .joins("JOIN answer_choices AS all_answer_choices ON all_answer_choices.question_id = questions.id")
    .joins("JOIN responses AS sibling_responses ON sibling_responses.answer_choice_id = all_answer_choices.id")
    .where("answer_choices.id = ?", answer_choice_id)
    .where("? IS NULL OR sibling_responses.id != ?", id, id)
  end

  def respondent_has_not_already_answered_question
    if sibling_responses.exists?(responder_user_id: responder_user_id)
      errors[:respondent] << "has already answered this question"
    end
  end

  def author_is_not_respondent
    poll = Poll.joins(:questions => :responses).where("answer_choice_id = ?", answer_choice_id).first
    if poll.author_id == responder_user_id
      errors[:author] << "can not respond to their own poll!"
    end
  end





end
