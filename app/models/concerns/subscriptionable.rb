module Subscriptionable
  extend ActiveSupport::Concern
  included do
    has_many :subscriptions, as: :subscriptionable, dependent: :destroy
  end
end
