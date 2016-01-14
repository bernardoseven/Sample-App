class UsersController < ApplicationController
  def show
    @user = User.find(params[:id]) # we retrieve the user from the database by id.
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
    else
      render 'new'
    end
  end
  
  private
  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
    # this code makes posible the create method code to work.
  end
end
