class MediaItem::Metadata::WebArticle < MediaItem::Metadata::BaseMetadata
  def title
    web_document.title
  end

  def consumption_time
    estimated_minutes_to_read.seconds
  end

  private

  WORDS_PER_MINUTE = 200.0

  def estimated_minutes_to_read
    (words_in_web_document.size / WORDS_PER_MINUTE).ceil.minutes
  end

  def words_in_web_document
    @web_document_content ||= web_document.content.squish.split(' ')
  end

  def web_document
    return @web_document if @web_document.present?

    raw_content = URI.open(media_item.url).read
    @web_document = Readability::Document.new(raw_content, tags: [], remove_empty_nodes: true)
  end
end
