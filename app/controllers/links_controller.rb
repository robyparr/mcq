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
    @link = current_user.links.create(link_params)

    if @link
      flash[:notice] = 'Created new link'
      redirect_to links_path
    else
      render :new
    end
  end

  def edit
    @link = current_user.links.find(params[:id])
  end

  def update
    @link = current_user.links.find(params[:id])

    if @link.update(link_params)
      flash[:notice] = 'Updated link'
      redirect_to link_path(@link)
    else
      render :edit
    end
  end

  def destroy
    @link = current_user.links.find(params[:id])

    if @link.destroy
      flash[:notice] = "Link '#{@link.title}' deleted."
      redirect_to links_path
    end
  end

  private

  def link_params
    params.require(:link).permit(:title, :description, :url)
  end
end
