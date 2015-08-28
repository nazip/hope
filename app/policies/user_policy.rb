class UserPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      # scope.where.not(id: user.id)
    end
  end

  def me?
    has_user? and user.id == record.id
  end

  def index?
    has_user?
  end
end
