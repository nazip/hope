class Question < ActiveRecord::Base
  belongs_to :user
  has_many :attachments, as: :attachable, dependent: :destroy
  has_many :answers, -> { order('best DESC') }, dependent: :destroy
  validates :title, :body, :user_id, presence: true
  validates :body, length: { minimum: 5, maximum: 140 }

  accepts_nested_attributes_for :attachments,
                                allow_destroy: true,
                                reject_if: proc { |a| a['file'].blank? }
end
