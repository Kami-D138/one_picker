class Menu < ApplicationRecord
  belongs_to :user
  belongs_to :genre
  belongs_to :type
  validates  :name,  presence: true
  validates  :recipe, presence: true
  validates  :ingredient,  presence: true
  validates  :memo, length: {maximum: 150}
  validates  :user_id, presence: true
  mount_uploader :image, ImageUploader
end
