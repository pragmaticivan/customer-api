class Customer < ActiveRecord::Base
  has_many :addresses

  validates :name, presence: true
  validates :email, presence: true
  validates :dob, presence: true
  validates :phone, presence: true
end
