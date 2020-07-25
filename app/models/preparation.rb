class Preparation < ApplicationRecord
  belongs_to :menu
  validates :step, presence: true
end
