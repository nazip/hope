class QuestionPolicy < ApplicationPolicy

  class Scope < Scope
    def resolve
      scope
    end
  end

  def create?
    !user.nil?
  end

  def index?
    true
  end

  def new?
    !user.nil?
  end

  def show?
    !user.nil?
  end

  def destroy?
    owner?
  end

  def update?
    owner?
  end
end
