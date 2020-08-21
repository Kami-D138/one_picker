class Ingredient < ApplicationRecord
  belongs_to :menu
  validates  :item, presence: true
end
