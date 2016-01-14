class UsersController < ApplicationController
  def show
    @user = User.find(params[:id]) # we retrieve the user from the database by id.
  end
  
  def new
    @user = User.new # instance variable for the form_for helper method.
  end
end
