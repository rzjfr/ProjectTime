Rails.application.routes.draw do
  root 'welcome#index'

  resources :projects
  resources :projects do
    member do
      get :statistics
      get :searches
    end
  end

  resources :project_members, only: [:create, :destroy]
  resources :milestones, only: [:create, :destroy, :update, :edit]
  resources :tasks, only: [:create, :destroy, :update, :edit]
  resources :tasks do
    collection do
      post :send_next_state
      post :postpone_task
    end
  end

  devise_for :users, path: '',
    :path_names => {sign_up: "signup", sign_in: "login", sign_out: "logout"}
end
