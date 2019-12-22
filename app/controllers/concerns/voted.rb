module Voted
  extend ActiveSupport::Concern

  included do
    before_action :find_voted, only: :vote
  end

  def vote
    unless current_user.is_author?(@voted)
      @voted.votes.create!(votes_params.merge(user: current_user))

      render json: { votable_type: @voted.class.to_s.downcase,
                     votable_id: @voted.id,
                     rating: @voted.rating }
    end
  end

  private

  def votes_params
    params.require(:voted).permit(:value)
  end

  def model_klass
    controller_name.classify.constantize
  end

  def find_voted
    @voted = model_klass.find(params[:id])
  end
end
