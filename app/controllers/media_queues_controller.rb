class MediaQueuesController < ApplicationController
  def new
    @queue = MediaQueue.new
  end

  def edit
    @queue = current_user.queues.find(params[:id])
  end

  def create
    @queue = current_user.queues.build(queue_params)

    if @queue.save
      redirect_to media_items_path(queue: @queue), notice: 'Queue was successfully created.'
    else
      flash[:error] = 'There was an error creating the queue'
      render :new
    end
  end

  def update
    @queue = current_user.queues.find(params[:id])

    if @queue.update(queue_params)
      redirect_to media_items_path(queue: @queue), notice: 'Queue was successfully updated.'
    else
      flash[:error] = 'There was an error creating the queue'
      render :edit
    end
  end

  def destroy
    @queue = current_user.queues.find(params[:id])
    @queue.destroy

    redirect_to media_items_path, notice: 'Queue was successfully destroyed.'
  end

  private

  def queue_params
    params.require(:media_queue).permit(:name, :color)
  end
end
