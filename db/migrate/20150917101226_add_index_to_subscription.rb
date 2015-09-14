class AddIndexToSubscription < ActiveRecord::Migration
  def change
    add_index :subscriptions,  [:subscriptionable_id, :subscriptionable_type], name: 'subscription_id_and_type'
  end
end
