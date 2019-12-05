FactoryBot.define do
  factory :media_queue, aliases: [:queue] do
    name  { 'A Queue' }
    color { '#fff' }
    user
  end
end
