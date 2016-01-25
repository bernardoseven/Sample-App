class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy,
                                        :following, :followers]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: :destroy
  
  def index
    @users = User.paginate(page: params[:page])
  end
  
  def show
    @user = User.find(params[:id]) # we retrieve the user from the database by id.
    @microposts = @user.microposts.paginate(page: params[:page])
  end
  
  def new
    @user = User.new # instance variable for the form_for helper method.
  end
  
  def create
    @user = User.new(user_params) # User.new(params[:user]) is equivalent
    # to User.new(name: "", email: "", password: "", password_confirmation: ""),
    # but is dangerous because we can pass values via de form like, administrator
    # attribute, so we have to only allow the parameters above and nothing more.
    # this can be accomplished with the code params.require(:user).permit(:name, 
    # :email, :password, :password_confirmation). To facilitate this, we can 
    # use an auxiliary method called user_params and use it in place of params[:user],
    # leaving the code like the one used above.
    if @user.save
      #log_in @user # logs in a user inmediately afther signing up.
      #flash[:success] = "Welcome to my app" # display a message when someone register was
      # succefull, and visits a page for the first time. This code needs more code
      # in the application.html.erb file.
      #redirect_to @user # redirects to the user path, we could have used the equivalent
      # code: redirect_to user_url(@user).
      @user.send_activation_email
      flash[:info] = "Please check your email to activate your account."
      redirect_to root_url
    else
      render 'new'
    end
  end
  
  def edit
    @user = User.find(params[:id])
  end
  
  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params) # handle a successful update.
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      render 'edit'
    end
  end
  
  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User deleted"
    redirect_to users_url
  end
  
  def following
    @title = "Following"
    @user  = User.find(params[:id])
    @users = @user.following.paginate(page: params[:page])
    render 'show_follow'
  end

  def followers
    @title = "Followers"
    @user  = User.find(params[:id])
    @users = @user.followers.paginate(page: params[:page])
    render 'show_follow'
  end
  
  private
  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
    # this code makes posible the create method code to work.
  end

  # confirms the correct user.
  def correct_user # now we have to use this method with a before filter action on the top.
    @user = User.find(params[:id])
    redirect_to(root_url) unless current_user?(@user)
  end
  # confirms an admin user.
  def admin_user
    redirect_to(root_url) unless current_user.admin?
  end
end
