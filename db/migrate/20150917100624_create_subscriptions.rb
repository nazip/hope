class CreateSubscriptions < ActiveRecord::Migration
  def change
    create_table :subscriptions do |t|
      t.references :user, index: true, foreign_key: true
      t.integer :subscriptionable_id
      t.string  :subscriptionable_type
      t.timestamps null: false
    end
  end
end

