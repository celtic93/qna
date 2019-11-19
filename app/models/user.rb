class User < ApplicationRecord
  has_many :questions

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
end
