FactoryBot.define do
  factory :contact do
    name { Faker::Name.name }
    email { Faker::Internet.unique.email }
    birthdate { Faker::Date.birthday(min_age: 18) }
    kind_id { create(:kind).id }
  end
end
