Rails.application.routes.draw do
  devise_for :users, :controllers => {
    :registrations => 'users/registrations',
    :sessions => 'users/sessions'}

  root 'home#welcome'
  get  '/home/top',           to: 'home#top'
  get  '/home/common_recipe', to: 'home#common_recipe'
  get  '/home/my_recipe',     to: 'home#my_recipe'
  get  '/admins/users_index', to: 'admins#users_index'
  
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources  :menus
end
