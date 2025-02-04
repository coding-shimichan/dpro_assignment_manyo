FactoryBot.define do
  factory :user do
    name { "Test User 1" }
    email { "test.user1@sample.com" }
    password { "password" }
    password_confirmation { "password" }
    admin { false }
  end

  factory :admin_user, class: User do
    name { "Admin User 1" }
    email { "admin.user1@sample.com" }
    password { "password" }
    password_confirmation { "password" }
    admin { true }
  end
end
