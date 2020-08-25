class SafetiesController < ApplicationController

  # 認証チェック（Helperでチェックする）
  before_action :require_user_logged_in, only: [:index, :edit, :update]

  def index
    #logger.debug("ここ＝" + (params[:disaster_id]))

    disaster_id = params[:disaster_id]
    
    # 災害idで抽出したdisasterを$disasterにセット
    @disaster = Disaster.find(disaster_id)

    # 災害idで抽出したSafety_userを@Safety_userにセット
    @safety_users = SafetyUser.where(disaster_id: @disaster).order(updated_at: :desc)
    #logger.debug("@safety_users.length＝" + @safety_users.length.to_s)
    
    # ログインユーザー
    user = current_user
    # ユーザーが管理者の場合
    @admin = nil;
    if user.admin == '9'
        @admin = "admin";
    end
  end


  def edit
    #logger.debug("ここ＝" + (params[:id]))
    # ログインユーザー
    @user = current_user
    @disaster = []

    # ユーザーが管理者の場合は選択されたユーザーのsafety
    if @user.admin == '9'
      safety_user =  SafetyUser.find(params[:id]);
      @user = User.find(safety_user.user_id);
      @disaster = Disaster.find(safety_user.disaster_id);
      @safety = safety_user.safety();
    # ユーザーが一般の場合はログインユーザーのsafety
    else
      # ユーザーが一般の場合はログインユーザーのsafety
      # 直近のsafety１つを$safetyにセット
      @safety = @user.latestSafety
      # safetyに登録されたdisaster
      if @safety != nil
        @disaster = @safety.disaster
      end
    end
  end

  def update
    #logger.debug("ここ＝" + (params[:id]))
    @safety = Safety.find(params[:id])
    if @safety.update(request_params)
      redirect_back fallback_location: root_path, flash: {       
          danger: '安否情報は更新されました。',
      }  and return
    else
      redirect_back fallback_location: root_path, flash: {       
          danger: '安否情報の更新に失敗しました。',
          warning: @disaster.errors.full_messages
      }  and return
    end
  end

  # ↓プライベート
  private

  # Strong Parameter（ストロングパラメータ） start
  # formからのパラメータ
  def request_params
    params.require(:safety).permit(:myself, :contact_information)
  end
  # Strong Parameter（ストロングパラメータ） start


end
