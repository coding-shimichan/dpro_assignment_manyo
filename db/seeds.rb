# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
50.times do |n|
  Task.create!(
    title: "Task #{n}",
    content: "Task content #{n}",
    created_at: n.day.from_now,
    updated_at: n.day.from_now,
    deadline_on: (n+1).day.from_now,
    priority: rand(max=3),
    status: rand(max=3)
  )
end