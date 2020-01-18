class User < ApplicationRecord
  has_many :questions
  has_many :answers
  has_many :awards
  has_many :votes
  has_many :comments
  has_many :authorizations, dependent: :destroy

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable, :omniauthable, omniauth_providers: %i(github vkontakte)

  TEMP_EMAIL_REGEX = /\Achange@me/

  def is_author?(resource)
    self.id == resource.user_id
  end

  def voted?(resource)
    votes.where(votable: resource).present?
  end

  def self.find_for_oauth(auth)
    Services::FindForOauth.new(auth).call
  end

  def email_verified?
    email && email !~ TEMP_EMAIL_REGEX
  end
end
