class Article < MediaItem
  def retrieve_metadata_from_source!
  end

  def estimate_consumption_time!
    return nil unless url.present?

    raw_content = URI.open(url).read
    document = Readability::Document.new(raw_content, tags: [], remove_empty_nodes: true)

    words = document.content.squish.split(' ').size
    minutes_to_read = (words / 200.0).ceil.minutes

    self.estimated_consumption_time = minutes_to_read.seconds
  end
end
