class SessionsController < ApplicationController
  def new
  end
  
  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password]) # authenticate appeared
    # as authenticated in the tutorial, change as it is and works fine. //ignore this
      log_in user
      params[:session][:remember_me] == '1' ? remember(user) : forget(user)# as with log_in,
      redirect_back_or user # once again the helper does it all.
    else
      flash.now[:danger] = "Invalid email/password combination"
      render 'new'
    end
  end
  
  def destroy
    # logs out the current user by destroyin the session and redirects to root_path
    log_out if logged_in? # fix the problem of having to windows of the app open when
    # logging out.
    redirect_to root_url
  end
end
