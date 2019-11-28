class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user

  validates :body, presence: true
  validates :best, exclusion: { in: [nil] }, uniqueness: { scope: :question_id, best: true }, if: :best
end
