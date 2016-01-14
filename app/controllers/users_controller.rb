class UsersController < ApplicationController
  def show
    @user = User.find(params[:id]) # we retrieve the user from the database by id.
  end
  
  def new
  end
end
