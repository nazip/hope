class Question < ActiveRecord::Base
    has_many :answers, dependent: :destroy
    validates :title, :body, presence: true
    validates :body, length: { minimum: 5, maximum: 140}
end
