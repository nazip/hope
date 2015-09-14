class AddAdminAndReputationToUser < ActiveRecord::Migration
  def change
    add_column :users, :admin, :boolean, default: false
    add_column :users, :reputation, :integer, default: 0
  end
end
