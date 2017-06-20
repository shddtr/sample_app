# coding: utf-8
class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
    # debugger
  end

  def new
    @user = User.new
    # debugger
  end

  def create
    # debugger
    @user = User.new(user_params)
    if @user.save
      log_in(@user)
      # :successは慣習的
      flash[:success] = "Welcome to the Sample App!"
      # 以下のコードは等価
      # redirect_to user_url(@user)
      redirect_to @user
    else
      render 'new'
    end
  end

  private
  def user_params
    params.require(:user).permit(:name, :email, :password,
                                 :password_confirmation)
  end
end
