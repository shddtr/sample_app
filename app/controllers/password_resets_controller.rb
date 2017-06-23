# coding: utf-8
class PasswordResetsController < ApplicationController
  before_action :get_user, only: [:edit, :update]
  before_action :valid_user, only: [:edit, :update]
  before_action :check_expiration, only: [:edit, :update]

  def new
  end

  def create
    @user = User.find_by(email: params[:password_reset][:email].downcase)
    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:info] = "Email sent with password reset instructions"
      redirect_to root_url
    else
      flash[:danger] = "Email address no found"
      render 'new'
    end
  end

  def edit
  end

  def update
    if params[:user][:password].empty?
      # パスワードが空の場合
      @user.errors.add(:password, "can't be empty")
      render 'edit'
    elsif @user.update_attributes(user_params)
      # パスワードが空でない場合
      log_in @user
      @user.update_attribute(:reset_digest, nil)
      flash[:success] = "Password has been reset."
      redirect_to @user
    else
      # 失敗した場合
      render 'edit'
    end
  end

  private
  def user_params
    params.require(:user).permit(:password, :password_confirmation)
  end

  def get_user
    @user = User.find_by(email: params[:email].downcase)
  end

  def valid_user
    unless @user && @user.activated? &&
           @user.authenticated?(:reset, params[:id])
      redirect_to root_url
    end
  end

  def check_expiration
    if @user.password_reset_expired?
      # 有効期限過ぎてる
      flash[:danger] = "Password reset has expired."
      redirect_to new_password_reset_url
    end
  end
end
