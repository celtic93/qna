class AnswersController < ApplicationController
  before_action :authenticate_user!, except: %i(show)
  before_action :find_question, only: %i(new create)
  before_action :find_answer, only: %i(show edit update destroy)

  def new
    @answer = @question.answers.new
  end

  def show
  end

  def edit
  end

  def create
    @answer = @question.answers.new(answer_params)
    @answer.user = current_user

    if @answer.save
      redirect_to @question, notice: 'Your answer succesfully created.'
    else
      redirect_to @question, alert: @answer.errors.full_messages
    end
  end

  def update
    if current_user.is_author?(@answer) && @answer.update(answer_params)
      redirect_to @answer
    else
      render :edit
    end
  end

  def destroy
    if current_user.is_author?(@answer)
      @answer.destroy
      redirect_to @answer.question, notice: 'Answer succesfully deleted.'
    else
      redirect_to @answer.question, notice: "You can't delete someone else's answer"
    end
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
end
