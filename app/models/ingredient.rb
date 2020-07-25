class Ingredient < ApplicationRecord
  belongs_to :menu, dependent: :destroy
  validates  :item, presence: true
end
