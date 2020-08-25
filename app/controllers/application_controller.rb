class ApplicationController < ActionController::Base
  
  # Helper（app\helpers）の読み込み
  include SessionsHelper
  
  private

  # リクエストがゲストの時はloginへredirect
  def require_user_logged_in
    unless logged_in?
      redirect_to login_url
    end
  end

end
