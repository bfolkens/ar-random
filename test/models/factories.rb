FactoryGirl.define do
  factory :item do
    name { Faker::Lorem.words(3).join(' ') }
  end
end