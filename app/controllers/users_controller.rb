class UsersController < ApplicationController
  def index
    @users = User.all
    @user = User.new
  end

  def new
    @user = User.new
  end

  def create
    @user = User.create(user_params)
    login(@user)
    redirect_to @user
  end

  def show
    @user = User.find_by_id(params[:id])
    if (current_user != @user)
      flash[:error] = 'Stop Hacking!'
      redirect_to '/'
    end
  end

  private
  def user_params
    params.require(:user).permit(:user_name, :email, :password)
  end
end
