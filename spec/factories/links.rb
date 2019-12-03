FactoryBot.define do
  factory :link do
    title       { 'Link title' }
    description { 'This is a link.' }
    url         { 'https://example.com' }
    user
  end
end
