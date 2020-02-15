require 'rails_helper'

RSpec.describe Services::NewAnswerSending do
  let(:question) { build(:question) }
  let(:answer) { create(:answer, question: question) }
  let(:subscription) { build(:subscription, user: question.user) }
  let(:subscription2) { create(:subscription, question: question) }
  let(:unsubscriber) { build(:user) }
  let(:subscribers) { [subscription.user, subscription2.user] }

  it 'sends answer for all subscribers' do
    subscribers.each {|subscriber| expect(NewAnswerMailer).to receive(:send_answer).with(subscriber, answer).and_call_original}
    subject.send_answer(answer)
  end

  it 'does not send answer for unsubscriber' do
    expect(NewAnswerMailer).to_not receive(:send_answer).with(unsubscriber, answer)
  end
end
