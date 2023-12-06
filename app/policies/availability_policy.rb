class AvailabilityPolicy < ApplicationPolicy
  class Scope < Scope
    # NOTE: Be explicit about which records you allow access to!
    # def resolve
    #   scope.all
    # end
  end

  def create?
    true
  end

  def edit?
    user == record.user
  end

  alias_method :update?, :edit?
  alias_method :destroy?, :edit?
end
