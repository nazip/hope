class AddQuestionIdAndAnswerIdToElect < ActiveRecord::Migration
  def change
    add_column :elects, :electable_id, :integer
    add_column :elects, :electable_type, :string
    add_index :elects, [:electable_id, :electable_type]
  end
end
