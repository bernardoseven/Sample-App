class SessionsController < ApplicationController
  def new
  end
  
  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password]) # authenticate appeared
    # as authenticated in the tutorial, change as it is and works fine.
      log_in user
      remember user # as with log_in, defers the real work to the sessions Helper.
      redirect_to user # rails convert this to the route for the user's profile page.
    else
      flash.now[:danger] = "Invalid email/password combination"
      render 'new'
    end
  end
  
  def destroy
    # logs out the current user by destroyin the session and redirects to root_path
    log_out
    redirect_to root_url
  end
end
