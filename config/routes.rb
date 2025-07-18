Rails.application.routes.draw do
  scope "(:locale)", locale: /vi|en/ do
    get "static_pages/home"
    get "static_pages/help"
    get "static_pages/contact"
    get "microposts/index"
    
    resources :microposts, only: [:index]
    
    root "static_pages#home"
  end
  
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
end
