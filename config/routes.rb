Rails.application.routes.draw do
  devise_for :users, :controllers => {
    :registrations => 'users/registrations',
    :sessions => 'users/sessions'}

  root 'home#welcome'
  get  '/home/top',           to: 'home#top'
  get  '/home/common_recipe', to: 'home#common_recipe'
  get  '/home/my_recipe',     to: 'home#my_recipe'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources  :menus
  resources  :admins, only: [:index, :show, :destroy]
end
