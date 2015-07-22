module Electable
  extend ActiveSupport::Concern
  included do
    has_many :elects, as: :electable, dependent: :destroy
  end

  def sum_elects
    Elect.where(electable: self).sum(:election)
  end

  def elects_id user
    Elect.select(:id).where(electable: self, user_id: user).sum(:id)
  end
end
