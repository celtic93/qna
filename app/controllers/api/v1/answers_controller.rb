class Api::V1::AnswersController < Api::V1::BaseController
  before_action :find_question, only: %i(index)
  before_action :find_answer, only: %i(show)

  authorize_resource

  def index
    render json: @question.answers
  end

  def show
    render json: @answer
  end

  private

  def find_answer
    @answer = Answer.with_attached_files.find(params[:id])
  end

  def find_question
    @question = Question.find(params[:question_id])
  end
end
