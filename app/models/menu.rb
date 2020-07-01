class Menu < ApplicationRecord
  belongs_to :user
  validates  :name,  presence: true
  validates  :recipe, presence: true
  validates  :ingredient,  presence: true
  validates  :memo, length: {maximum: 150}
end
