class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  include SessionsHelper # includes the sessions helper into all the controllers.
  
  private
  # confirms a logged-in user.
  def logged_in_user # takes advantage of sessions methods helper. This method is used
  # in the before_action filter at the top of this file(users controller).
    unless logged_in?
      store_location
      flash[:danger] = "Please log in."
      redirect_to login_url
    end
  end
end
