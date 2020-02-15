class Answer < ApplicationRecord
  include Linkable
  include Votable
  include Commentable
  
  belongs_to :question
  belongs_to :user

  has_many_attached :files

  validates :body, presence: true
  validates :best, uniqueness: { scope: :question_id, best: true }, if: :best?

  after_commit :send_for_subscribers, on: :create

  default_scope { order('best DESC, created_at') }

  def make_best!
    transaction do
      question.answers.update_all(best: false)
      update!(best: true)
      question.award&.update!(user: user)
    end
  end

  private

  def send_for_subscribers
    NewAnswerJob.perform_later(self)
  end
end
