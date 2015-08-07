class UpdateTypeOfElection < ActiveRecord::Migration
  def change
    remove_column :elects, :election, :boolean
    add_column :elects, :election, :integer, default: 0
  end
end
