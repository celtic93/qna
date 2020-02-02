class Api::V1::QuestionsController < Api::V1::BaseController
  before_action :find_question, only: %i(show)

  authorize_resource

  def index
    @questions = Question.all
    render json: @questions
  end

  def show
    render json: @question
  end

  private

  def find_question
    @question = Question.with_attached_files.find(params[:id])
  end
end
