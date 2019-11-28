class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user

  validates :body, presence: true
  validates :best, exclusion: { in: [nil] }, uniqueness: { scope: :question_id, best: true }, if: :best

  def make_best
    transaction do
      question.answers.update_all(best: false)
      update(best: true)
    end
  end
end
