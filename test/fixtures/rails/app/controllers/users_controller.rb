class UsersController < ApplicationController
  def index
     @users = User.all
  end
  
  def show
    @user = User.find(params[:id])
  end

  def create
    user = User.new(params[:user])
    if user.save
      redirect_to user_url(user)
    else
      render :text => 'nope', :status => :unprocessable_entity
    end
  end
end
