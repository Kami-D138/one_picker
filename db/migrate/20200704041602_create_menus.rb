class CreateMenus < ActiveRecord::Migration[5.1]
  def change
    create_table :menus do |t|
      t.string :name
      t.text :recipe
      t.text :ingredient
      t.string :memo
      t.integer :status
      t.references :user, foreign_key: true
      t.references :type, foreign_key: true
      t.references :genre, foreign_key: true

      t.timestamps
    end
  end
end
