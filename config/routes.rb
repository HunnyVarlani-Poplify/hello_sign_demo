Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  post 'signature/check', to: 'signature#check'
  post 'signature/create', to: "signature#create"
  root to: 'home#index'
end
