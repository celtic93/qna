class AnswersController < ApplicationController
  before_action :authenticate_user!, except: %i(show)
  before_action :find_question, only: %i(new create)
  before_action :find_answer, only: %i(show edit update destroy best)
  before_action :check_author, only: %i(update destroy)

  def new
    @answer = Answer.new
  end

  def show
  end

  def edit
  end

  def create
    @answer = @question.answers.new(answer_params)
    @answer.user = current_user
    @answer.save
  end

  def update
    @answer.update(answer_params)
    @question = @answer.question
  end

  def best
    @question = @answer.question

    if current_user.is_author?(@question)
      @answer.make_best
    else
      redirect_to @question
    end
  end

  def destroy
    @answer.destroy
  end

  private

  def find_question
    @question = Question.find(params[:question_id])
  end

  def find_answer
    @answer = Answer.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:body)
  end

  def check_author
    redirect_to @answer.question, notice: 'Only author can do it' unless current_user.is_author?(@answer)
  end
end
