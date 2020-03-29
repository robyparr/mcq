class MediaItemsPresenter
  def initialize(user, media_items_relation, params)
    @user = user
    @media_items_relation = media_items_relation
    @params = params
  end

  def media_items
    @media_items ||= FindMediaItems.call(media_items_relation, params)
  end

  def filter_priorities
    @filter_priorities ||= user.media_priorities.pluck(:title, :id)
  end

  def queues
    @queues ||= user.queues
  end

  private

    attr_reader :media_items_relation,
                :params,
                :user
end