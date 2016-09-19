FactoryGirl.define do
  factory :user do
    first_name "user1"
    last_name  "u"
    email "user@user.com"
    password "password"
    role  "admin"
  end
end