class ChangeSubscribers < ActiveRecord::Migration
  def change
    remove_reference :subscribers, :question, index: true, foreign_key: true
    add_column :subscribers, :subscriberable_id, :integer
    add_column :subscribers, :subscriberable_type, :string
    add_index :subscribers, [:subscriberable_id, :subscriberable_type]
  end
end
