class User < ApplicationRecord
  has_many :menus
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  validates  :name,  presence: true
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
end
