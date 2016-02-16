class Customer < ActiveRecord::Base
  validates :name, presence: true
  validates :email, presence: true
  validates :dob, presence: true
  validates :phone, presence: true
end
