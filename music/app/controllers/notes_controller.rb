class NotesController < ApplicationController

  def new # separate into a new controller
    @note = Note.new(
    user_id: current_user.id,
    track_id: params[:track_id],
    body: note_params[:body]
    )
    flash.now[:errors] = @note.errors.full_messages unless @note.save
    redirect_to track_url(@note.track_id)
  end

  def destroy
    @note = Note.find(params[:id])
    if @note.user == current_user
      Note.destroy(@note.id)
    else
      raise "This is not your note!", status: 403
    end
    redirect_to track_url(@note.track_id)
  end

  def note_params
    params.require(:note).permit(:body)
  end
end
