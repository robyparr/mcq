FactoryBot.define do
  factory :media_item do
    title       { 'Media title' }
    description { 'This is a media item.' }
    url         { 'https://example.com' }
    user
    queue
  end
end
