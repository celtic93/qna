class SubscriptionsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_question

  authorize_resource

  def create
    @subscription = @question.subscriptions.create!(user: current_user)
  end

  def destroy
    @subscription = @question.subscriptions.find_by!(user: current_user)
    @subscription.destroy
  end

  private

  def find_question
    @question = Question.find(params[:id])
  end
end
