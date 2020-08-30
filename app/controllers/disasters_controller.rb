class DisastersController < ApplicationController

  # 認証チェック（Helperでチェックする）
  before_action :require_user_logged_in, only: [:new, :create, :edit, :update, :destroy]

  # 災害一覧
  def index
    if logged_in?
      # ユーザーが管理者の場合
      if current_user.admin == '9'
          # 災害一覧を@disastersにセット
          # 災害一覧へ
          @disasters = Disaster.order(created_at: :desc) # ページネーション.page(params[:page])はやめる
      # ユーザーが一般の場合
      else
          # 安否確認へリダイレクト
          # safetiesコントローラーのeditアクションのid=current_user.id（ここではidではない）へリダイレクト
          redirect_to controller: 'safeties', action: 'edit', id: current_user.id
      end
    else
      # ログインへリダイレクト
      redirect_to login_url
    end
  end

  # 災害登録確認
  def new
    @users = [];

    # getのURLパラメータを@disaster_nameにする。
    @disaster_name = {
      name: request_url_params,
    }
    # バリデーション
    @disaster = Disaster.new(@disaster_name)
    unless @disaster.valid?
      redirect_back fallback_location: root_path, flash: {       
          warning: @disaster.errors.full_messages
      }  and return
    end

    # 全ユーザー（管理者以外）の安否をcreateする対象userを抽出する。
    allUsers = User.all(); 
    allUsers.each do |user|
      if user.admin != "9"
        @users.push(user);
      end
    end
  end

  # 災害登録確認
  def create
    @disaster = Disaster.new(request_params)
    unless @disaster.save
      # バリデーションもFlashメッセージで元画面にリダイレクト
      # return new だとemail等を@パラメータにしてreturnしないとemail等が画面に表示されない。
      redirect_back fallback_location: root_path, flash: {       
          danger: '災害情報の登録に失敗しました。',
          warning: @disaster.errors.full_messages
      }  and return
    end

    # 全ユーザー（管理者以外）の安否をcreateする。
    allUsers = User.all(); 
    @mails = [];

    allUsers.each do |user|
      if user.admin != "9"
        # 既に登録済みかの確認
        exist = Safety.exists?(disaster_id: @disaster.id , user_id: user.id)
        if !exist
        # 未登録であれば登録する
          safety = Safety.new
          safety.disaster_id = @disaster.id
          safety.user_id = user.id
          safety.myself = "不明"
          safety.contact_information = ""
          unless safety.save
            # バリデーションもFlashメッセージで元画面にリダイレクト
            # return new だとemail等を@パラメータにしてreturnしないとemail等が画面に表示されない。
            redirect_back fallback_location: root_path, flash: {       
                danger: '安否情報の登録に失敗しました。',
                warning: @disaster.errors.full_messages
            }  and return
          end
          #emailを@mailsにセット
          @mails.push(user.email);
        end
      end
    end
    redirect_to disasters_url
  end

  def edit
    @disaster = Disaster.find(params[:id])
  end

  def update
    @disaster = Disaster.find(params[:id])

    if @disaster.update(request_params)
      redirect_to disasters_url
    else
      flash.now[:danger] = '災害情報の更新は失敗しました。'
      render :edit
    end
  end

  def destroy
    @disaster = Disaster.find(params[:id])
    @disaster.destroy
    redirect_to disasters_url
  end

  # ↓プライベート
  private

  # Strong Parameter（ストロングパラメータ） start
  # indexのformからのgetでのURLパラメータ
  def request_url_params
    # nameパラメータが無い場合には代わりに""返す。
    unless params[:name].blank?
      return params[:name].to_s
    else
      return ""
    end
  end

  # newのformからのパラメータ
  def request_params
    params.require(:disaster).permit(:name,)
  end
  # Strong Parameter（ストロングパラメータ） start

end
