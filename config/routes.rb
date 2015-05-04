Rails.application.routes.draw do
  root 'welcome#index'

  resources :projects

  resources :project_members, only: [:create, :destroy]
  resources :milestones, only: [:create, :destroy, :update, :edit]
  resources :tasks, only: [:create, :destroy, :update, :edit]

  devise_for :users, path: '',
    :path_names => {sign_up: "signup", sign_in: "login", sign_out: "logout"}
end
