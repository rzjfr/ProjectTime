Rails.application.routes.draw do

  unauthenticated do
    devise_scope :user do
      root 'welcome#index'
    end
  end

  authenticated :user do
    root :to => "projects#project_board", :as => "project_board"
  end

  get "project_board" => "projects#project_board"
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
      post :update_row_order
    end
  end

  devise_for :users, path: '',
    :path_names => {sign_up: "signup", sign_in: "login", sign_out: "logout"}

  post "versions/:id/revert" => "versions#revert", as: "revert_version"

end
