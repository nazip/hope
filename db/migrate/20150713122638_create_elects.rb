class CreateElects < ActiveRecord::Migration
  def change
    create_table :elects do |t|
      t.boolean :election

      t.timestamps null: false
    end
  end
end
