class Answer < ActiveRecord::Base
  belongs_to :question
  belongs_to :user
  validates :body, :question_id, :user_id, presence: true

  def update_best
    question.answers.where(best: true).update_all(best: false) unless best
    update!(best: !best)
  end
end
