class AddForeignKeyToAnswer < ActiveRecord::Migration
  def change
    add_column :answers, :question_id, :integer
    add_foreign_key :answers, :questions
  end
end
