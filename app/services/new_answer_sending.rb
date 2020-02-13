class Services::NewAnswerSending
  def send_answer(answer)
    answer.question.subscriptions.find_each do |subscription|
      user = subscription.user
      NewAnswerMailer.send_answer(user, answer).deliver_later unless user.is_author?(answer)
    end
  end
end
