Alvernon::Application.routes.draw do

  get "reports/search"

  devise_for :users, :controllers => { :invitations => 'users/invitations' }
  
  namespace :users do
    resource :update_password, :only => [:edit, :update]
  end

  resources :clients
  resources :qualifications
  resources :client_tokens, only: [:new, :create, :destroy]

  namespace :reports do
    resources :mpis, :path => 'mpi'
    resources :ets, :path => 'et'
    resources :ultrasonics, :path => 'ut'
    resources :radiographics, :path => 'rt' do
      member do
        get 'flashes'
      end
    end
    resources :pts, :path => 'pt'
    resources :visuals, :path => 'visual'
    
  end

  resources :editable_images
  
  match "lookup" => "home#lookup"
  match "updates" => "home#updates"

  match "emails/add_report" => "emails#add_report", via: :post
  match "emails/remove_report" => "emails#remove_report", via: :post
  match "emails/review" => "emails#show", via: :post
  match "emails/remove_from_editor" => "emails#remove_report_from_editor", via: :post
  match "emails/new_emails" => "emails#new_emails", via: :post
  match "emails/clear_new_emails" => "emails#clear_new_emails", via: :post

  match "confirm_user_delete/:id" => "home#confirm_user_delete", via: :post
  match "delete_user/:id" => "home#delete_user", via: :delete
  match "deleted_users" => "home#deleted_users", as: :deleted_users
  match "undelete_user/:id" => "home#undelete_user", via: :post

  match "receive_notifications/:id" => "home#receive_notifications", via: :post, as: :receive_notifications
  match "dont_receive_notifications/:id" => "home#dont_receive_notifications", via: :post, as: :dont_receive_notifications

  match "clients/:id/approve" => "clients#approve", as: :approve_client, via: :put
  match "clients_list" => "clients#list"
  match "client_emails/:id" => "clients#emails"
  match "merge_client/:source/with/:target" => "clients#merge"
  match "client_suggestions" => "clients#suggestions"
  
  match "admin/technicians" => "admin/users#technicians", :as => :admin_technicians
  match "admin/admins" => "admin/users#admins", :as => :admin_admins
  match "admin/pending" => "admin/users#pending", :as => :admin_pending
  match "admin/clients" => "admin/users#clients", :as => :admin_clients
  match "admin/suspended" => "admin/users#suspended", :as => :admin_suspended
  match "admin/users/restore/:id" => "admin/users#restore", :as => :admin_restore
  match "admin/users/suspend/:id" => "admin/users#suspend", :as => :admin_restore

  match "admin/users" => "home#users", :as => :admin_users
  match "users/resend_invitation/:id" => "home#resend_invitation"
  match "users/cancel_invitation/:id" => "home#cancel_invitation"
  match "users/promote/:id" => "home#promote"
  match "users/demote/:id" => "home#demote"
  match "account" => "home#account", :as => :account
  match "update_account" => "home#update_account", :via => :put
  match "remove_signature" => "home#remove_signature", :via => :put
  match "reports/:field" => "reports#search"
  match "send_via_email/:id" => "reports#send_via_email", :via => :post
  match "send_multiple_via_email" => "reports#send_multiple_via_email", :via => :post
  match "search" => "reports#full_search"    

  post "/tinymce_assets" => "tinymce_assets#create"

  #get "home/index"

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
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

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  root :to => 'home#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
