guest_user = User.guest

start_day = DateTime.new(2021, 8, 1)
last_day = DateTime.new(2021, 10, 31)

50.times do
  guest_user.events.create!(
    name: Faker::Hobby.activity,
    start_time: Random.rand(start_day..last_day),
  )
end
