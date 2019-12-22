class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: %i(index show)
  before_action :find_question, only: %i(show edit update destroy)
  before_action :check_author, only: %i(update destroy)

  def index
    @questions = Question.all
  end

  def show
    @answer = Answer.new 
    @answer.links.new
  end

  def new
    @question = Question.new
    @question.links.new
    @question.award = Award.new
  end

  def edit
  end

  def create
    @question = current_user.questions.new(question_params)
    
    redirect_to @question, notice: 'Your question succesfully created.' if @question.save
  end

  def update
    @question.update(question_params)
  end

  def destroy
    @question.destroy
    redirect_to questions_path, notice: 'Question succesfully deleted.'
  end

  private

  def find_question
    @question = Question.with_attached_files.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :body, files: [],
                                     links_attributes: [:id, :name, :url, :_destroy],
                                     award_attributes: [:title, :image])
  end

  def check_author
    redirect_to @question, notice: 'Only author can do it' unless current_user.is_author?(@question)
  end
end
