class AvailabilityPolicy < ApplicationPolicy
  class Scope < Scope
    # NOTE: Be explicit about which records you allow access to!
    # def resolve
    #   scope.all
    # end
  end

  def update?
    user == record.user
  end

  def destroy?
    user == record.user
  end
end
