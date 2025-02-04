# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
user = User.create!(
  name: "Test User 1",
  email: "test.user1@sample.com",
  password: "password",
  password_confirmation: "password",
  admin: false
)

admin = User.create!(
  name: "Admin User 1",
  email: "admin.user1@sample.com",
  password: "password",
  password_confirmation: "password",
  admin: true
)

50.times do |n|
  user.tasks.create!(
    title: "Task #{n}",
    content: "Task content #{n}",
    created_at: n.day.from_now,
    updated_at: n.day.from_now,
    deadline_on: (n+1).day.from_now,
    priority: rand(max=3),
    status: rand(max=3)
  )
end

50.times do |n|
  admin.tasks.create!(
    title: "Task #{n}",
    content: "Task content #{n}",
    created_at: n.day.from_now,
    updated_at: n.day.from_now,
    deadline_on: (n+1).day.from_now,
    priority: rand(max=3),
    status: rand(max=3)
  )
end