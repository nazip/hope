class AddUsedIdToElect < ActiveRecord::Migration
  def change
    add_column :elects, :user_id, :integer
    add_index :elects, :user_id
  end
end
