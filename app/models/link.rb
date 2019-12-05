class Link < ApplicationRecord
  belongs_to :user

  validates :url, presence: true

  def title_or_url
    title.presence || url
  end
end
