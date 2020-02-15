require 'rails_helper'

RSpec.describe Services::DailyDigest do
  let(:users) { create_list(:user, 2) }

  context 'with yesterday questions' do
    let!(:question) { create(:question, created_at: Date.yesterday, user: users[0]) }

    it 'sends daily digest to all users' do
      users.each {|user| expect(DailyDigestMailer).to receive(:digest).with(user).and_call_original}
      subject.send_digest
    end
  end

  context 'with no yesterday questions' do
    it 'does not send daily digest to all users' do
      users.each {|user| expect(DailyDigestMailer).to_not receive(:digest).with(user)}
      subject.send_digest
    end
  end
end
