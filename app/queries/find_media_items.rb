class FindMediaItems < ApplicationQuery
  def initialize(relation = nil, params = {})
    @relation = relation || default_relation
    @params   = params
  end

  def call
    relation
      .then(&method(:filter_by_difficulty))
      .then(&method(:filter_by_media_priority))
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
end
