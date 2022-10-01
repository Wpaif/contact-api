FactoryBot.define do
  factory :address do
    street { Faker::Address.street_name }
    city { Faker::Address.city }
    contact { create(:contact) }
  end
end
