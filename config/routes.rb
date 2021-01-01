Rails.application.routes.draw do
    root to: 'tasks#index'
    
    resources :tasks
    
    get 'signup', to: 'users#new'
    resources :users, only: [ :new, :create]
end
