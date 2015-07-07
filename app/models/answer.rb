class Answer < ActiveRecord::Base
  belongs_to :question
  belongs_to :user
  has_many :attachments, as: :attachable, dependent: :destroy
  validates :body, :question_id, :user_id, presence: true

  accepts_nested_attributes_for :attachments,
                                allow_destroy: true,
                                reject_if: proc { |a| a['file'].blank? }

  def update_best
    question.answers.where(best: true).update_all(best: false) unless best
    update!(best: !best)
  end
end
