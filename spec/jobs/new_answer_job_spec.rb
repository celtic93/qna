require 'rails_helper'

RSpec.describe NewAnswerJob, type: :job do
  let(:service) { double('Services::NewAnswerSending') }
  let(:answer) { build(:answer) }

  before { allow(Services::NewAnswerSending).to receive(:new).and_return(service) }

  it 'calls Services::DailyDigest#send_answer' do
    expect(service).to receive(:send_answer).with(answer)
    NewAnswerJob.perform_now(answer)
  end
end
