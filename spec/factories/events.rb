FactoryBot.define do
  factory :event do
    lorem_description = Faker::Lorem.paragraphs(number: 5).join(' ')
    start_day = DateTime.now - 15.days
    last_day = DateTime.now + 15.days
    randomized_time = Random.rand(start_day..last_day)

    name { Faker::Hobby.activity }
    description { lorem_description }
    start_time { randomized_time }
    end_time { randomized_time + 5.hours }

    association :user
  end
end
