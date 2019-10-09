# frozen_string_literal: true

class Ability
  include CanCan::Ability

  attr_reader :user

  def initialize(user)
    @user = user
      if user
        user.admin? ? admin_abilities : user_abilities
      else
        guest_abilities
      end
  end

  def guest_abilities
    can :read, :all
  end

  def admin_abilities
    can :manage, :all
  end

  def user_abilities
    guest_abilities
    can :create, [Question, Answer, Comment]
    can :update, [Question, Answer, Comment], user: user
    can :destroy, [Question, Answer, Comment], user: user

    alias_action :vote_up, :vote_down, :vote_clear, to: :vote
    can :vote, [Question, Answer] do |resource|
      user.not_creator?(resource)
    end

    can :select_best, Answer do |answer|
      user.creator?(answer.question) && !answer.best?
    end

    can :destroy, ActiveStorage::Attachment do |attachment|
      user.creator?(attachment.record)
    end
  end
end
