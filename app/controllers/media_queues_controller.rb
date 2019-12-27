class MediaQueuesController < ApplicationController
  def index
    @queues = current_user.queues.includes(:active_links)
  end

  def show
    @queue = current_user.queues.includes(:active_links).find(params[:id])
  end

  def new
    @queue = current_user.queues.new
  end

  def edit
    @queue = current_user.queues.find(params[:id])
  end

  def create
    @queue = current_user.queues.build(queue_params)

    if @queue.save
      redirect_to queue_path(@queue), notice: 'Queue was successfully created.'
    else
      flash[:error] = 'There was an error creating the queue'
      render :new
    end
  end

  def update
    @queue = current_user.queues.find(params[:id])

    if @queue.update(queue_params)
      redirect_to queue_path(@queue), notice: 'Queue was successfully updated.'
    else
      flash[:error] = 'There was an error creating the queue'
      render :edit
    end
  end

  def destroy
    @queue = current_user.queues.find(params[:id])
    @queue.destroy

    redirect_to queues_url, notice: 'Queue was successfully destroyed.'
  end

  private

  def queue_params
    params.require(:media_queue).permit(:name, :color)
  end
end
