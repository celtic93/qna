require 'rails_helper'

RSpec.describe DailyDigestMailer, type: :mailer do
  describe 'digest' do
    let(:user) { create(:user) }
    let(:mail) { DailyDigestMailer.digest(user) }
    let!(:yesterday_question) { create(:question, created_at: Date.yesterday) }
    let!(:today_question) { create(:question, title: 'Today question', created_at: Date.today) }

    it 'renders the headers' do
      expect(mail.subject).to eq 'New QNA questions'
      expect(mail.to).to eq [user.email]
    end

    it 'renders the body' do
      expect(mail.body.encoded).to match yesterday_question.title
      expect(mail.body.encoded).to_not match today_question.title
    end
  end
end
