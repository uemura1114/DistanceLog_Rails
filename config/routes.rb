Rails.application.routes.draw do
  get 'mypage', to: 'users#me'
  post 'login', to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy'
  get 'how', to: 'distances#how'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'home#index'
  resources :users, only: [:new, :create]
  resources :distances, only: [:index, :new, :create, :show, :destroy]
  
end
