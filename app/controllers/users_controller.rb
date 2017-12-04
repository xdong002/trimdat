class UsersController < ApplicationController
  def index
    @users = User.all
    @user = User.new
  end

  def new
    @user = User.new
  end

  def create
    if User.find_by({:user_name => user_params[:user_name]}) != nil
      flash[:error] = "User name already exists. Please try again"
      redirect_to root_path
    else
      @user = User.create(user_params)
      flash[:success] = "Welcome, #{@user.user_name}!"
      login(@user)
      redirect_to @user
    end
  end

  def show
    @user = User.find_by_id(params[:id])
    @documents = @user.documents
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
