require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many :questions }
  it { should have_many :answers }
  it { should have_many :awards }
  it { should have_many :votes }
  it { should have_many :comments }
  it { should have_many(:authorizations).dependent(:destroy) }

  it { should validate_presence_of :email }
  it { should validate_presence_of :password }

  let!(:questions) { create_list(:question, 2)}
  let!(:user) { create(:user) }
  let!(:vote) { create(:vote, user: user, votable: questions[0])}

  it 'shows whether the user voted' do
    expect(user.voted?(questions[0])).to be_truthy
    expect(user.voted?(questions[1])).to be_falsey
  end

  describe '.find_for_oauth' do
    let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '123') }
    let(:service) { double('Services::FindForOauth') }

    it 'calls Services::FindForOauth' do
      expect(Services::FindForOauth).to receive(:new).with(auth).and_return(service)
      expect(service).to receive(:call)
      User.find_for_oauth(auth)
    end
  end
end
