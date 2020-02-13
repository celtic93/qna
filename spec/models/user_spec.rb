require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many :questions }
  it { should have_many :answers }
  it { should have_many :awards }
  it { should have_many :votes }
  it { should have_many :comments }
  it { should have_many(:authorizations).dependent(:destroy) }
  it { should have_many(:subscriptions).dependent(:destroy) }

  it { should validate_presence_of :email }
  it { should validate_presence_of :password }

  let!(:questions) { create_list(:question, 2)}
  let!(:user) { create(:user) }
  let!(:vote) { create(:vote, user: user, votable: questions[0])}

  it 'shows whether the user voted' do
    expect(user).to be_voted(questions[0])
    expect(user).to_not be_voted(questions[1])
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

  describe '.subscribed?' do
    let(:author) { create(:user) }
    let(:user) { create(:user) }
    let(:question) { create(:question, user: author) }
    let(:question2) { create(:question) }
    let!(:subscription) { create(:subscription, user: user, question: question2)}

    it 'should be subscribed' do
      expect(author).to be_subscribed(question)
      expect(user).to be_subscribed(question2)
    end

    it 'should not be subscribed' do
      expect(user).to_not be_subscribed(question)
      expect(author).to_not be_subscribed(question2)
    end
  end
end
