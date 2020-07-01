class CreateMenus < ActiveRecord::Migration[5.1]
  def change
    create_table :menus do |t|
      t.string :name
      t.text :recipe
      t.text :ingredient
      t.text :memo
      t.integer :status
      t.integer :user_id
      t.integer :type_id
      t.integer :genre_id

      t.timestamps
    end
  end
end