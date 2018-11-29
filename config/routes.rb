Rails.application.routes.draw do
  mount RailsAdmin::Engine => '/backoffice', as: 'rails_admin'
  devise_for :admin, path: "/zhorik", class_name: "Admin"

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  get '/' => 'application#index'
end
