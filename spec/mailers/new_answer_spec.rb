require 'rails_helper'

RSpec.describe NewAnswerMailer, type: :mailer do
  describe 'send_answer' do
    let(:question) { build(:question) }
    let(:user) { question.user }
    let(:answer) { build(:answer, question: question) }
    let(:mail) { NewAnswerMailer.send_answer(user, answer) }

    it 'renders the headers' do
      expect(mail.subject).to eq "New answer for #{question.title} question"
      expect(mail.to).to eq [user.email]
    end

    it 'renders the body' do
      expect(mail.body.encoded).to match answer.body
    end
  end
end
