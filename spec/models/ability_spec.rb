require 'rails_helper'

describe Ability, type: :model do
  subject(:ability) { Ability.new(user) }

  describe 'for guest' do
    let(:user) { nil }

    it { should be_able_to :read, Question }
    it { should be_able_to :read, Answer }
    it { should be_able_to :read, Comment }

    it { should_not be_able_to :read, Award }
    it { should_not be_able_to :manage, :all }
  end

  describe 'for user' do
    let(:user) { create :user }
    let(:question) { create(:question, :with_file, user: user) }
    let(:answer) { create(:answer, user: user, question: question) }
    let(:other_user) { create :user }
    let(:other_question) { create(:question, :with_file, user: other_user) }
    let(:other_answer) { create(:answer, user: other_user, question: other_question) }
    

    it { should be_able_to :read, Question }
    it { should be_able_to :read, Answer }
    it { should be_able_to :read, Comment }
    it { should be_able_to :read, Award }

    it { should be_able_to :create, Question }
    it { should be_able_to :create, Answer }
    it { should be_able_to :create, Comment }

    it { should be_able_to :update, question }
    it { should_not be_able_to :update, other_question }
    it { should be_able_to :update, answer }
    it { should_not be_able_to :update, other_answer }

    it { should be_able_to :destroy, answer }
    it { should_not be_able_to :destroy, other_answer }
    it { should be_able_to :destroy, question }
    it { should_not be_able_to :destroy, other_question }
    it { should be_able_to :destroy, question.files.first }
    it { should_not be_able_to :destroy, other_question.files.first }

    it { should_not be_able_to :vote, question }
    it { should be_able_to :vote, other_question }
    it { should_not be_able_to :vote, answer }
    it { should be_able_to :vote, other_answer }

    it { should_not be_able_to :revote, question }
    it { should be_able_to :revote, other_question }
    it { should_not be_able_to :revote, answer }
    it { should be_able_to :revote, other_answer }

    it { should be_able_to :best, answer }
    it { should_not be_able_to :best, other_answer }
  end
end
