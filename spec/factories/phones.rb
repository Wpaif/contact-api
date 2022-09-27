FactoryBot.define do
  factory :phone do
    number { Faker::PhoneNumber.phone_number }
    contact { create :contact }
  end
end
