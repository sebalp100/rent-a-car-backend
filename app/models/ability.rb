# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user (not logged in)

    if user.role == "admin"
      can :manage, :all
    elsif user.role == "client"
      can :read, :all
      can [:create, :destroy, :update], Rental
    else
      can :read, Car
      can :read, Brand
    end
  end
end
