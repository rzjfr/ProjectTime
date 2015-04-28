Rails.application.routes.draw do
  root 'welcome#index'

  #devise_for :users
  devise_for :users, path: '',
    :path_names => {sign_up: "signup", sign_in: "login", sign_out: "logout"}
end
