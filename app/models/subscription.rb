class Subscription < ActiveRecord::Base
  belongs_to :subscriptionable, polymorphic: true, touch: true
  belongs_to :user
end
