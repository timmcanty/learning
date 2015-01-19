class Question < ActiveRecord::Base

  validates :text, presence: true
  validates :poll_id, presence: true

  belongs_to(
    :poll,
    class_name: "Poll",
    foreign_key: :poll_id,
    primary_key: :id
  )

  has_many(
    :answer_choices,
    class_name: "AnswerChoice",
    foreign_key: :question_id,
    primary_key: :id,
    dependent: :destroy
  )

  has_many :responses, through: :answer_choices, source: :responses

  def results
    hist = {}
    results = self
    .answer_choices
    .select("answer_choices.*, COUNT(responses.id) AS frequency")
    .joins("LEFT OUTER JOIN responses ON answer_choices.id = responses.answer_choice_id")
    .group("answer_choices.id")

    results.each do |result|
      hist[result.text] = result.frequency
    end

    hist
  end

  # def results_nplusone
  #   answers = answer_choices
  #   results = {}
  #
  #   answers.each do |answer|
  #     results[answer.text] = answer.responses.count
  #   end
  #
  #   results
  # end

  # def results_sloppy
  #   answers = answer_choices.includes(:responses)
  #   results = {}
  #
  #   answers.each do |answer|
  #     results[answer.text] = answer.responses.length
  #   end
  #
  #   results
  # end



end
