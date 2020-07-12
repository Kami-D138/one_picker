Rails.application.routes.draw do
  devise_for :users, :controllers => {
    :registrations => 'users/registrations',
    :sessions => 'users/sessions'   
  } 
  root 'home#welcome'
  get  '/home/top',    to: 'home#top'
  get  '/home/sample', to: 'home#sample'
  get  '/home/my_sample', to: 'home#my_sample'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources  :menus
end
