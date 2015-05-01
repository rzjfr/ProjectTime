Rails.application.routes.draw do
  root 'welcome#index'

  resources :projects

  resources :project_members, only: [:create, :destroy]

  devise_for :users, path: '',
    :path_names => {sign_up: "signup", sign_in: "login", sign_out: "logout"}
end
