class MediaItemsController < ApplicationController
  def index
    query_relation = current_user.media_items.includes(:queue, :priority)
    @presenter = MediaItemsPresenter.new(current_user, query_relation, params: params)
  end

  def show
    @media_item = current_user.media_items.includes(:notes).find(params[:id])
  end

  def new
    @media_item = current_user.media_items.new
  end

  def create
    @media_item = current_user.media_items.build(media_item_params)

    if @media_item.valid?
      @media_item.retrieve_metadata_from_source!
      @media_item.estimate_consumption_time!
      if @media_item.consumption_difficulty.blank?
        @media_item.estimate_consumption_difficulty!
      end
      @media_item.save

      redirect_to media_item_path(@media_item), notice: 'Added the media.'
    else
      flash[:error] = 'There was an error adding the media.'
      render :new
    end
  end

  def edit
    @media_item = current_user.media_items.find(params[:id])
  end

  def update
    @media_item = current_user.media_items.find(params[:id])

    if @media_item.update(media_item_params)
      redirect_to media_item_path(@media_item), notice: 'Updated the media.'
    else
      flash[:error] = 'There was an error editing the media.'
      render :edit
    end
  end

  def destroy
    @media_item = current_user.media_items.find(params[:id])

    if @media_item.destroy
      redirect_to_media_list notice: "Media '#{@media_item.title_or_url}' deleted."
    end
  end

  def complete
    @media_item = current_user.media_items.find(params[:id])

    if @media_item.mark_complete
      redirect_to media_item_path(@media_item), notice: 'Marked media as completed.'
    else
      flash[:error] = 'There was an error marking the media as completed.'
      render :show
    end
  end

  def snooze
    @media_item = current_user.media_items.find(params[:id])

    snooze_until = params[:snooze_until]
    snooze_until = Time.zone.parse(snooze_until) if snooze_until.present?
    if @media_item.snooze(until_time: snooze_until)
      notice =
        if snooze_until.nil?
          'Media item was unsnoozed.'
        else
          "Snoozed until #{@media_item.snooze_until}"
        end
      redirect_to media_item_path(@media_item), notice: notice
    else
      flash[:error] = 'There was an error snoozing the media.'
      render :show
    end
  end

  def bulk_change_queue
    queue = current_user.queues.find(params[:queue_id])
    updated_items = current_user.media_items.where(id: bulk_ids).update_all media_queue_id: queue.id

    flash[:notice] = "Moved #{updated_items} media items to '#{queue.name}'."
    redirect_ajax_to bulk_action_redirect_location(fallback: media_items_url)
  end

  def bulk_mark_completed
    media_items = current_user.media_items.not_completed.where(id: bulk_ids)
    ActiveRecord::Base.transaction do
      media_items.each { |media_item| media_item.mark_complete }
    end

    flash[:notice] = "Marked #{media_items.size} media items as completed."
    redirect_ajax_to bulk_action_redirect_location(fallback: media_items_url)
  end

  def bulk_destroy
    destroyed_items = current_user.media_items.where(id: bulk_ids).destroy_all

    flash[:notice] = "Deleted #{destroyed_items.size} media items."
    redirect_ajax_to bulk_action_redirect_location(fallback: media_items_url)
  end

  private

  def media_item_params
    params.require(:media_item).permit(
      :url,
      :title,
      :media_queue_id,
      :media_priority_id,
      :consumption_difficulty,
      :type,
    )
  end

  def bulk_ids
    params[:ids].split(',')
  end
end
