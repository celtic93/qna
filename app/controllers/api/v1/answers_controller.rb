class Api::V1::AnswersController < Api::V1::BaseController
  before_action :find_question, only: %i(index)

  authorize_resource

  def index
    render json: @question.answers
  end

  private

  def find_question
    @question = Question.find(params[:question_id])
  end
end
