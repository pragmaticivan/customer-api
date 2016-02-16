require 'rails_helper'

describe Customer, type: :model do
  context 'validations' do
    it { should validate_presence_of :name }
    it { should validate_presence_of :email }
    it { should validate_presence_of :dob }
    it { should validate_presence_of :phone }
  end
end
