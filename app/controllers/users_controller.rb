class UsersController < ApplicationController
  
  # 認証チェック（Helperでチェックする）
  before_action :require_user_logged_in, only: [:edit, :update, :destroy]

  def new
    @user = User.new
  end

  def create
    @user = User.new(request_params)
    
    # adminの設定
    admin = "0"
    if @user.phone == "090-xxxx-xxxx"
      admin = "9"
    end
    @user.admin = admin

    if @user.save
      flash[:success] = 'ユーザを登録しました。'
      redirect_to root_url
    else
      flash.now[:danger] = 'ユーザの登録に失敗しました。'
      render :new
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])

    if @user.update(request_params)
      flash.now[:danger] = 'ユーザ情報を更新しました。'
      render :edit
    else
      flash.now[:danger] = 'ユーザ情報の更新は失敗しました。'
      render :edit
    end
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy
    redirect_to root_url
  end

  # ↓プライベート
  private

  # Strong Parameter（ストロングパラメータ） start
  # formからのパラメータ
  def request_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :phone)
  end
  # Strong Parameter（ストロングパラメータ） start

end
