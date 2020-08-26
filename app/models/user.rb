class User < ApplicationRecord
  has_many :menus
  validates  :name,  presence: true
  validates  :email, uniqueness: true, presence: true
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
end
