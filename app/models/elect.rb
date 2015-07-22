class Elect < ActiveRecord::Base
  belongs_to :electable, polymorphic: true
  belongs_to :user
  validates :election, presence: true, inclusion: { in: [-1, 1] }
  validates :electable_type, presence: true, inclusion: { in: ['Question', 'Answer'] }
  validates :user_id, presence: true
  validates :electable_id, presence: true, uniqueness: { scope: [:electable_type, :user_id] }
end
