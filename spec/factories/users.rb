FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "example#{n}@examepl.com" }
    password         { 'password' }
  end
end
