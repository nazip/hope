class SubscriptionPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope
    end
  end

  def create?
    !user.nil?
  end

  def destroy?
    !user.nil? and owner?
  end
end
