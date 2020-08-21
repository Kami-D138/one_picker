Rails.application.routes.draw do
  devise_for :users, :controllers => {
    :registrations => 'users/registrations',
    :sessions => 'users/sessions',
    :passwords => 'users/passwords'}

  devise_scope :user do
    get 'users', to: 'users/registrations#new'
    post 'users', to: 'users/registrations#create'
    get 'users/password', to: 'users/passwords#new'
    post 'users/password', to: 'users/passwords#create'
  end

  root 'home#top'
  get  '/home/common_recipe', to: 'home#common_recipe'
  get  '/home/my_recipe',     to: 'home#my_recipe'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources  :menus
  resources  :admins, only: [:index, :show, :destroy]
end
