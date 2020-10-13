class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :authenticate_user!
  layout :layout_by_resource

  protected

  def layout_by_resource
    if devise_controller?
      'devise_layout'
    else
      'application'
    end
  end

  def authorize_admin!
    authenticate_user!

    return if current_user.admin?

    flash[:alert] = 'You must be an admin to access this resource!'
    redirect_to root_path
  end
end
