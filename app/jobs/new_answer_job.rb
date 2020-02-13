class NewAnswerJob < ApplicationJob
  queue_as :default

  def perform(answer)
    Services::NewAnswerSending.new.send_answer(answer)
  end
end
