class Address < ActiveRecord::Base
  belongs_to :customer

  validates :line1, presence: true
  validates :city, presence: true
  validates :state, presence: true
  validates :zip, presence: true
end
