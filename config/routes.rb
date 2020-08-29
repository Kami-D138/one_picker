Rails.application.routes.draw do
  devise_for :users, :controllers => {
    :registrations => 'users/registrations',
    :sessions => 'users/sessions',
    :passwords => 'users/passwords'}

  devise_scope :user do
    get 'users',              to: 'users/registrations#new'
    post 'users',             to: 'users/registrations#create'
    get 'users/password',     to: 'users/passwords#new'
    post 'users/password',    to: 'users/passwords#create'
  end

  root 'home#top'
  get  '/home/common_recipe', to: 'home#common_recipe'
  get  '/home/my_recipe',     to: 'home#my_recipe'

  resources  :menus
  resources  :admins, only: [:index, :show, :destroy]
  resources  :users, only: [:show, :edit, :update, :destroy]

  post '/callback',            to: 'linebot#callback'
end
