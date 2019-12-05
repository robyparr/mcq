class LinksController < ApplicationController
  def index
    @links = current_user.links
  end

  def show
    @link = current_user.links.find(params[:id])
  end

  def new
    @link = current_user.links.new
  end

  def create
    @link = current_user.links.build(link_params)

    if @link.save
      redirect_to link_path(@link), notice: 'Created new link'
    else
      flash[:error] = 'There was an error creating the link'
      render :new
    end
  end

  def edit
    @link = current_user.links.find(params[:id])
  end

  def update
    @link = current_user.links.find(params[:id])

    if @link.update(link_params)
      redirect_to link_path(@link), notice: 'Updated link'
    else
      flash[:error] = 'There was an error editing the link'
      render :edit
    end
  end

  def destroy
    @link = current_user.links.find(params[:id])

    if @link.destroy
      redirect_to links_path, notice: "Link '#{@link.title_or_url}' deleted."
    end
  end

  private

  def link_params
    params.require(:link).permit(:url, :title, :media_queue_id)
  end
end
