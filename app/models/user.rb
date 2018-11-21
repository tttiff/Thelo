class User < ApplicationRecord
  has_many :events
  has_many :bids
  has_many :user_services, dependent: :destroy
  has_many :services, through: :user_services
  has_many :reviews, dependent: :destroy

  has_many :orders
  validates_presence_of :first_name, :last_name, :password
  validates :email, uniqueness: { case_sensitive: false }

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
end
