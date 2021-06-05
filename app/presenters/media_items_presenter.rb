class MediaItemsPresenter
  include ActionView::Context
  include ActionView::Helpers::TagHelper
  include Rails.application.routes.url_helpers

  def initialize(user, media_items_relation, params:, queue: nil)
    @user = user
    @media_items_relation = media_items_relation
    @params = params
    @queue = queue
  end

  def media_items
    params[:state] ||= :not_complete
    @media_items ||= FindMediaItems.call(media_items_relation, params).order(id: :desc).page(params[:page])
  end

  def filter_priorities
    @filter_priorities ||= user.media_priorities.pluck(:title, :id)
  end

  def no_media_items_message
    content_tag(:div, class: 'mt-20 flex flex-col items-center text-muted') do
      content_tag(:i, nil, class: 'text-5xl bi bi-inbox icon') +
      content_tag(:p, class: 'text-lg') do
        "You're all caught up!"
      end
    end
  end

  def path_for_media_item(media_item)
    media_item_path(media_item, queue: queue)
  end

  private

    attr_reader :media_items_relation,
                :params,
                :user,
                :queue
end
