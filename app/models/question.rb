class Question < ApplicationRecord
  include Linkable
  include Votable
  include Commentable
  
  has_many :answers, dependent: :destroy
  has_many :subscriptions, dependent: :destroy
  has_one :award, dependent: :destroy
  belongs_to :user

  has_many_attached :files

  accepts_nested_attributes_for :award, reject_if: :all_blank
  
  validates :title, :body, presence: true

  after_create :new_answer_subscribe

  private

  def new_answer_subscribe
    subscriptions.create!(user: user)
  end
end
