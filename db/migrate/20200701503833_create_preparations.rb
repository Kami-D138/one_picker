class CreatePreparations < ActiveRecord::Migration[5.1]
  def change
    create_table :preparations do |t|
      t.string :step
      t.references :menu, foreign_key: true

      t.timestamps
    end
  end
end
