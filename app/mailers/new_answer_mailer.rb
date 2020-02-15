class NewAnswerMailer < ApplicationMailer
  def send_answer(user, answer)
    @answer = answer
    @question = answer.question
    
    mail to: user.email, subject: "New answer for #{@question.title} question"
  end
end
