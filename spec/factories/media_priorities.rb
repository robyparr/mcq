FactoryBot.define do
  factory :media_priority, aliases: [:priority] do
    title    { 'Top Priority' }
    priority { 1 }
    user
  end
end
