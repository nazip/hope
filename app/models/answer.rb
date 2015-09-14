class Answer < ActiveRecord::Base
  include Electable
  include Attachable
  include Commentable
  belongs_to :user
  belongs_to :question
  validates :body, :question_id, :user_id, presence: true

  after_create :answer_created

  def update_best
    question.answers.where(best: true).update_all(best: false) unless best
    update!(best: !best)
  end

  private

  def answer_created
    SendAnswer.send_email(self.question.user, self).deliver_later
    SendAnswerToSubscribersJob.perform_later(self)
  end
end
