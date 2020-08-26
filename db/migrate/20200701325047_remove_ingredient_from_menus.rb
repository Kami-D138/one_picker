class RemoveIngredientFromMenus < ActiveRecord::Migration[5.1]
  def change
    remove_column :menus, :ingredient, :text
  end
end
