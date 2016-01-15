module SessionsHelper
    # logs in the given user.
    def log_in(user)
        session[:user_id] = user.id
    end
    # remembers a user in a persistent session.
    def remember(user)
        user.remember
        cookies.permanent.signed[:user_id] = user.id
        cookies.permanent[:remember_token] = user.remember_token
    end
    # returns true if the given user is the current user.
    def current_user?(user)
        user == current_user
    end
    # return the user corresponding to the remember token cookie.
    def current_user
        if (user_id = session[:user_id])
            @current_user ||= User.find_by(id: user_id)
        elsif (user_id = cookies.signed[:user_id])
           user = User.find_by(id: user_id)
           if user && user.authenticate?(cookies[:remember_token]) # authenticate appeared
    # as authenticated? in the tutorial, change as it is and works fine. //Ignore this.
               log_in user
               @current_user = user
           end
        end
    end
    # returns true if the current user is logged in.
    def logged_in?
        !current_user.nil?
    end
    # 
    def forget(user)
      user.forget
      cookies.delete(:user_id)
      cookies.delete(:remember_token)
    end
    # logs out the current user.
    def log_out
        session.delete(:user_id)
        @current_user = nil
    end
end
