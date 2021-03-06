Faker::Config.locale = :en

guest_user = User.guest

lorem_description = Faker::Lorem.paragraphs(number: 5).join(' ')
start_day = DateTime.new(2021, 9, 1)
last_day = start_day + rand(30).days

20.times do
  randomized_time = Random.rand(start_day..last_day) + rand(24).hour + rand(60).minutes
  guest_user.events.create!(
    name: Faker::Hobby.activity,
    description: lorem_description,
    start_time: randomized_time,
    end_time: randomized_time + 1.hours,
  )
end

randomized_time = Random.rand(start_day..last_day) + rand(24).hour + rand(60).minutes

guest_user.events.create!(
  name: Faker::Hobby.activity,
  description: lorem_description,
  start_time: randomized_time,
  end_time: randomized_time,
)

randomized_time = Random.rand(start_day..last_day) + rand(24).hour + rand(60).minutes

guest_user.events.create!(
  name: Faker::Hobby.activity,
  description: lorem_description,
  start_time: randomized_time,
  end_time: randomized_time + 1.days,
)

randomized_time = Random.rand(start_day..last_day) + rand(24).hour + rand(60).minutes

guest_user.events.create!(
  name: Faker::Hobby.activity,
  description: lorem_description,
  start_time: randomized_time,
  end_time: randomized_time + 2.days,
)

randomized_time = Random.rand(start_day..last_day) + rand(24).hour + rand(60).minutes
guest_user.events.create!(
  name: 'a'*255,
  description: 'a'*2000,
  start_time: randomized_time,
  end_time: randomized_time + 1.hour,
)

start_day = DateTime.new(2021, 1, 1)
last_day = DateTime.new(2021, 12, 31)

180.times do
  randomized_time = Random.rand(start_day..last_day) + rand(24).hour + rand(60).minutes
  guest_user.events.create!(
    name: Faker::Hobby.activity,
    description: lorem_description,
    start_time: randomized_time,
    end_time: randomized_time + 1.hour,
  )
end
