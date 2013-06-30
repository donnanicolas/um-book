class ApplicationController < ActionController::Base
  protect_from_forgery

  def validate_friendship(user)
    if user.id != current_user.id && Friendship.find_by_users(current_user.id, user.id).nil?
      flash[:alert] = "No tiene permisos para continuar"
      redirect_to root_url
    end
  end
end
