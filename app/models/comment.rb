class Comment < ActiveRecord::Base
  belongs_to :commentable, polymorphic: true
  validates :body, presence: true
  validates :commentable_type, :commentable_id, presence: true
  validates :user_id, presence: true
end
