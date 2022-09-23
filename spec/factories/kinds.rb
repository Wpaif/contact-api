FactoryBot.define do
  factory :kind do
    description { Faker::Types.unique.rb_string }
  end
end
