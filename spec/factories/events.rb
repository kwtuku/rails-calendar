FactoryBot.define do
  factory :event do
    name { Faker::Hobby.activity }
    start_day = DateTime.now - 15.days
    last_day = DateTime.now + 15.days
    start_time { Random.rand(start_day..last_day) }
    association :user
  end
end
