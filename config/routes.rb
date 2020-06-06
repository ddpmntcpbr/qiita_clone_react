Rails.application.routes.draw do
  namespace :api, format: "json" do
    namespace :v1 do
      mount_devise_token_auth_for "User", at: "auth", controllers: {
        registrations: "api/v1/auth/registrations",
      }
      namespace "current" do
        resources :articles, only: [:index]
      end
      namespace "articles" do
        resources :drafts, only: [:index, :show]
      end
      resources :articles
    end
  end
end
