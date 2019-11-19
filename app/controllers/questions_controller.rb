class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: %i(index show)
  before_action :find_question, only: %i(show edit update destroy)

  def index
    @questions = Question.all
  end

  def show
    @answer = @question.answers.new 
  end

  def new
    @question = Question.new
  end

  def edit
  end

  def create
    @question = current_user.questions.new(question_params)

    if @question.save
      redirect_to @question, notice: 'Your question succesfully created.'
    else
      render :new
    end
  end

  def update
    if @question.update(question_params)
      redirect_to @question
    else
      render :edit
    end
  end

  def destroy
    if current_user == @question.user
      @question.destroy
      redirect_to questions_path, notice: 'Question succesfully deleted.'
    else
      redirect_to @question, notice: "You can't delete someone else's question"
    end
  end

  private

  def find_question
    @question = Question.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :body)
  end
end
