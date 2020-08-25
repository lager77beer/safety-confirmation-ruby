Rails.application.routes.draw do
  root to: 'disasters#index'

  # ユーザ登録
  get 'signup', to: 'users#new'
  post 'users', to: 'users#create'

  # ログイン認証
  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy'

  # 以下、認証okルート

  # ユーザ更新
  resources :users, only: [:edit, :update, :destroy]

  # 災害一覧
  resources :disasters, only: [:index, :new, :create, :edit, :update, :destroy]
  
  # 安否確認
  resources :safeties, only: [:edit, :update]
  # 安否確認ネスト（disasters/:disaster_id/safeties）
  resources :disasters do
    resources :safeties, only: [:index]
  end

end
