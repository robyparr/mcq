FactoryBot.define do
  factory :integration do
    user

    trait :pocket do
      service { 'Pocket' }
    end
  end
end
