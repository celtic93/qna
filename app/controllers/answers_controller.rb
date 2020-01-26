class AnswersController < ApplicationController
  include Voted
  
  before_action :authenticate_user!, except: %i(show)
  before_action :find_question, only: %i(new create)
  before_action :find_answer, only: %i(show edit update destroy best)

  after_action :publish_answer, only: %i(create)

  authorize_resource

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
    @answer.make_best!
  end

  def destroy
    @answer.destroy
  end

  private

  def find_question
    @question = Question.find(params[:question_id])
  end

  def find_answer
    @answer = Answer.with_attached_files.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:body, files: [], links_attributes: [:id, :name, :url, :_destroy])
  end

  def publish_answer
    return if @answer.errors.any?

    files = @answer.files.map do |file|
      {
        id: file.id,
        url: url_for(file),
        name: file.filename.to_s
      }
    end

    data = {
      answer: @answer,
      rating: @answer.rating,
      links: @answer.links,
      files: files,
      class_name: @answer.class.to_s.downcase,
      question_user_id: @answer.question.user.id
    }
    
    ActionCable.server.broadcast("question_#{@answer.question.id}", data)
  end
end
