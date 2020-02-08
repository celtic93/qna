class Ability
  include CanCan::Ability

  attr_reader :user

  def initialize(user)
    @user = user

    user ? user_abilities : guest_abilities 
  end

  private

  def guest_abilities
    can :read, [Question, Answer, Comment]
  end

  def user_abilities
    guest_abilities

    can :read, Award

    can :create, [Question, Answer, Comment]

    can [:update, :destroy], [Question, Answer], { user_id: user.id }

    can [:vote, :revote], [Question, Answer] do |voted|
      !user.is_author?(voted)
    end

    can :best, Answer do |answer|
      user.is_author?(answer.question)
    end

    can :destroy, ActiveStorage::Attachment do |attachment|
      user.is_author?(attachment.record)
    end

    can :me, User

    can :read, User
  end
end
