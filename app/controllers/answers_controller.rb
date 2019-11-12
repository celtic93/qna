class AnswersController < ApplicationController
  before_action :find_question, only: %i(new)
  before_action :find_answer, only: %i(show edit)

  def new
    @answer = @question.answers.new
  end

  def show
  end

  def edit
  end

  private

  def find_question
    @question = Question.find(params[:question_id])
  end

  def find_answer
    @answer = Answer.find(params[:id])
  end
end
