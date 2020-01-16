FactoryBot.define do
  factory :media_note do
    title   { 'A note' }
    content { 'Some note content.' }
    media_item
  end
end
