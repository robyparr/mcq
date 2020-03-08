FactoryBot.define do
  factory :integration do
    user
    sequence(:auth_token) { |n| "auth-token-#{n}" }

    trait :pocket do
      service { 'Pocket' }
    end
  end
end
