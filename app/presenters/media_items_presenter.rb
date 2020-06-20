class MediaItemsPresenter
  include ActionView::Context
  include ActionView::Helpers::TagHelper

  def initialize(user, media_items_relation, params)
    @user = user
    @media_items_relation = media_items_relation
    @params = params
  end

  def media_items
    params[:state] ||= :not_complete
    @media_items ||= FindMediaItems.call(media_items_relation, params).order(:id).page(params[:page])
  end

  def filter_priorities
    @filter_priorities ||= user.media_priorities.pluck(:title, :id)
  end

  def queues
    @queues ||= user.queues
  end

  def no_media_items_message
    content_tag(:div, class: 'mt-20 flex flex-col items-center text-muted') do
      content_tag(:i, nil, data: { feather: 'frown' }, class: 'w-20 h-20') +
      content_tag(:p, class: 'text-lg') do
        "It looks like you don't have any media yet."
      end
    end
  end

  private

    attr_reader :media_items_relation,
                :params,
                :user
end
