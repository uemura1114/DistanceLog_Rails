Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get 'distances', to: 'distances#index'
  post 'distances', to: 'distances#create'
  
end
