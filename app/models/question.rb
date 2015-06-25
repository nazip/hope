class Question < ActiveRecord::Base
  belongs_to :user
  has_many :answers, -> { order('best DESC') }, dependent: :destroy
  validates :title, :body, :user_id, presence: true
  validates :body, length: { minimum: 5, maximum: 140 }
end
