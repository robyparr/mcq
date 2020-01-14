class MediaPrioritiesController < ApplicationController
  def index
    @media_priority   = MediaPriority.new
    @media_priorities = current_user.media_priorities
  end

  def create
    params          = media_priority_params.merge(user_id: current_user.id)
    @media_priority = MediaPriority.new(params)

    if @media_priority.save
      redirect_to media_priorities_path, notice: 'Created new priority'
    else
      @media_priorities = current_user.media_priorities
      render :index
    end
  end

  private

  def media_priority_params
    params.require(:media_priority).permit(:title, :priority)
  end
end
