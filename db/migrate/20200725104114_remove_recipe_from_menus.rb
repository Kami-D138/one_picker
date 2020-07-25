class RemoveRecipeFromMenus < ActiveRecord::Migration[5.1]
  def change
    remove_column :menus, :recipe, :text
  end
end
