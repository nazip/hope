class AnswerPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope
    end
  end

  def new?
    has_user?
  end

  def create?
    has_user?
  end

  def destroy?
    owner?
  end

  def update?
    owner?
  end

  def best?
    has_user? and (record.question.user == user)
  end
end
