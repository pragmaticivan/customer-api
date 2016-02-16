FactoryGirl.define do
  factory :customer do
    name { Faker::Name.name }
    dob { Faker::Date.between(50.years.ago, 20.years.ago) }
    email { Faker::Internet.email }
    phone { Faker::PhoneNumber.phone_number }
  end
end
