class ElectPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope
    end
  end

  def create?
    !user.nil? and record.electable.user_id != user.id
  end

  def destroy?
    !user.nil? and owner?
  end
end
