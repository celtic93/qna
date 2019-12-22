require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many :questions }
  it { should have_many :answers }
  it { should have_many :awards }
  it { should have_many :votes }

  it { should validate_presence_of :email }
  it { should validate_presence_of :password }
end
