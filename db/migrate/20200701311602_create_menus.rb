class CreateMenus < ActiveRecord::Migration[5.1]
  def change
    create_table :menus do |t|
      t.string :name
      t.text :recipe
      t.string :memo
      t.integer :status
      t.references :user, foreign_key: true
      t.references :sub_genre, foreign_key: true
      t.references :genre, foreign_key: true

      t.timestamps
    end
  end
end
