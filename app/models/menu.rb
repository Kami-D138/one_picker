class Menu < ApplicationRecord
  has_many   :ingredients, dependent: :destroy
  has_many   :preparations, dependent: :destroy
  accepts_nested_attributes_for :ingredients, allow_destroy: true
  accepts_nested_attributes_for :preparations, allow_destroy: true
  belongs_to :user
  belongs_to :genre
  belongs_to :type
  validates  :name,  presence: true
  validates  :memo, length: {maximum: 150}
  validates  :user_id, presence: true
  mount_uploader :image, ImageUploader
end
