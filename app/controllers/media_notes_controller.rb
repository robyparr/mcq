class MediaNotesController < ApplicationController
  def create
    @media_note = media_item.notes.build(media_note_params)

    if @media_note.save
      render :create
    else
      render json: @media_note.errors.full_messages, status: :unprocessable_entity
    end
  end

  def update
    @media_note = current_user.notes.find(params[:id])

    if @media_note.update(media_note_params)
      render json: @media_note.to_json
    else
      render json: { errors: @media_note.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    @media_note = current_user.notes.find(params[:id])
    @media_note.destroy

    render :destroy
  end

  private

  def media_note_params
    params.require(:media_note).permit(
      :title,
      :content,
    )
  end

  def media_item
    current_user.media_items.find params[:media_item_id]
  end
end
