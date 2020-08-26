class ChangeTypesToSubGenres < ActiveRecord::Migration[5.1]
  def change
    rename_table :types, :sub_genres
  end
end
