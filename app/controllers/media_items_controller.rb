class MediaItemsController < ApplicationController
  def index
    @media_items = current_user.media_items.includes(:queue, :priority)
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
      redirect_to media_items_path, notice: "Media '#{@media_item.title_or_url}' deleted."
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

  private

  def media_item_params
    params.require(:media_item).permit(
      :url,
      :title,
      :media_queue_id,
      :media_priority_id,
      :consumption_difficulty,
    )
  end
end
