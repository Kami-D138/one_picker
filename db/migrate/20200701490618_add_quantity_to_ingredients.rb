class AddQuantityToIngredients < ActiveRecord::Migration[5.1]
  def change
    add_column :ingredients, :quantity, :string
  end
end
