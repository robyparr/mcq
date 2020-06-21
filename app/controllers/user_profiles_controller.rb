class UserProfilesController < ApplicationController
  layout 'settings'

  def show
  end

  def update
    if current_user.update(profile_params)
      redirect_to user_profile_path, notice: 'Successfully updated your profile.'
    else
      flash[:error] = 'There was an error updating your profile.'
      render :show
    end
  end

  private

  def profile_params
    params.require(:user).permit(:time_zone)
  end
end
