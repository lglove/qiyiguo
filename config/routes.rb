Rails.application.routes.draw do
   root 'home#index'
   get 'designer', to: 'home#designer'
   get 'designervideo', to: 'home#designervideo'
   get 'explain', to: 'home#explain'
   get 'political', to: 'home#political'
   get 'serve', to: 'home#serve'
   get 'use', to: 'home#use'
   get 'video', to: 'home#video'
   get 'register', to:'home#register'
   get 'personal', to:'home#personal'
   get 'personalAll', to:'home#personalAll'

   resources :users do
     collection do
       get :login
       get :logout
       post :info
       get :body
     end
   end
   resources :orders do
     collection do
       get :payment
       post :make_payment
       post :h5_make_payment
       get :make_order
       get :cancel_order
       post :notify
     end
   end

  resources :home do
    collection do
      post :mobile_register
      post :update_manner
      post :update_body
      post :mobile_validate
      post :password_update
      get :forgetpassword
      get :signin
      get :signout
      get :welcome
      get :manner_1
      get :manner_2
      get :manner_3
      get :manner_4
      get :manner_5
      get :manner_6
    end
  end

  namespace :admin do
    root 'main#welcome'
    resource :admins do
      collection do
        get :index
        get :rights
        post :set_right
        get :change_password
        post :update_password
        get :shanchu
      end
    end
    resource :users do
      collection do
        get :index
        post :info
        post :body
        get :zhanshi
        get :shanchu
      end
    end
    resource :orders do
      collection do
        get :index
        get :lianxi
        get :fahuo
        get :wancheng
        get :zhanshi
        get :shanchu
        post :user_amount
        post :month_amount
        post :invite_amount
      end
    end
    resource :videos do
      collection do
        get :index
        get :shanchu
      end
    end
    resource :designers do
      collection do
        get :index
        get :shanchu
      end
    end
    get 'main/welcome' => 'main#welcome'
    get 'main/login' => 'main#login'
    get 'main/logout' => 'main#logout'
    post 'main/signin' => 'main#signin'
  end
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
