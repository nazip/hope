class Answer < ActiveRecord::Base
  include Electable
  include Attachable
  belongs_to :user
  belongs_to :question
  validates :body, :question_id, :user_id, presence: true

  def update_best
    question.answers.where(best: true).update_all(best: false) unless best
    update!(best: !best)
  end
end
