require 'rails_helper'

describe Address, type: :model do
  context 'associations' do
    it { should belong_to :customer }
  end

  context 'validations' do
    it { should validate_presence_of :line1 }
    it { should validate_presence_of :city }
    it { should validate_presence_of :state }
    it { should validate_presence_of :zip }
    it { should validate_presence_of :customer }
  end
end
