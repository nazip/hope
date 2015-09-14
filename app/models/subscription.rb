class Subscription < ActiveRecord::Base
  belongs_to :subscriptionable, polymorphic: true
  belongs_to :user
end
