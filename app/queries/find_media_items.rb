class FindMediaItems < ApplicationQuery
  def initialize(relation = nil, params = {})
    @relation = relation || default_relation
    @params   = params
  end

  def call
    relation
      .then(&method(:filter_by_difficulty))
      .then(&method(:filter_by_media_priority))
      .then(&method(:filter_by_type))
      .then(&method(:filter_by_complete))
      .then(&method(:search))
  end

  private

  attr_reader :relation,
              :params

  def default_relation
    MediaItem.all.includes(:queue, :priority)
  end

  def filter_by_difficulty(relation)
    return relation unless params[:difficulty].present?

    relation.where(consumption_difficulty: params[:difficulty])
  end

  def filter_by_media_priority(relation)
    return relation unless params[:priority].present?

    relation.where(media_priorities: { id: params[:priority] })
  end

  def filter_by_type(relation)
    return relation unless params[:type].present?

    relation.where(type: params[:type])
  end

  def filter_by_complete(relation)
    return relation unless params.key?(:complete)

    relation.where(complete: params[:complete])
  end

  def search(relation)
    return relation unless params[:search].present?

    query_fragments = [
      'media_items.title ILIKE :query',
      'media_items.url ILIKE :query',
      'media_notes.title ILIKE :query',
      'media_notes.content ILIKE :query',
    ]
    relation.eager_load(:notes)
            .where(query_fragments.join(' OR '), query: "%#{params[:search]}%")
            .select('media_items.*')
  end
end
