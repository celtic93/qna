class Api::V1::AnswersController < Api::V1::BaseController
  before_action :find_question, only: %i(index create)
  before_action :find_answer, only: %i(show update destroy)

  authorize_resource

  def index
    @answers = @question.answers.includes(:links, :comments, :user).with_attached_files
    render json: @answers
  end

  def show
    render json: @answer
  end

  def create
    @answer = @question.answers.new(answer_params)
    @answer.user = current_resource_owner

    if @answer.save
      render json: @answer, status: :created
    else
      render json: { errors: @answer.errors }, status: :unprocessable_entity
    end
  end

  def update
    if @answer.update(answer_params)
      render json: @answer
    else
      render json: { errors: @answer.errors }, status: :unprocessable_entity
    end
  end

  def destroy
    if @answer.destroy!
      head :ok
    else
      render json: { errors: @answer.errors }, status: :unprocessable_entity
    end
  end

  private

  def find_answer
    @answer = Answer.with_attached_files.find(params[:id])
  end

  def find_question
    @question = Question.find(params[:question_id])
  end

  def answer_params
    params.require(:answer).permit(:body)
  end
end
