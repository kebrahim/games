Games::Application.routes.draw do
  resources :nba_playoff_bets
  get '/nbaPlayoffs' => 'nba_playoff_bets#allusers'
  get '/nbaPlayoffBets' => 'nba_playoff_bets#index'

  resources :nba_playoff_matchups
  get 'nba_playoff_matchups/:id/winner' => 'nba_playoff_matchups#setwinner'
  post 'nba_playoff_matchups/:id/winner' => 'nba_playoff_matchups#updatewinner'

  resources :nba_teams

  resources :mlb_win_bets
  post '/mlb_win_bets_save' => 'mlb_win_bets#bulksave'
  get '/mlbOverUnders' => 'mlb_win_bets#allusers'
  get '/mlbOverUnderBets' => 'mlb_win_bets#index'

  resources :mlb_wins

  resources :mlb_teams

  resources :users
  get 'sign_up' => 'users#new', :as => 'sign_up'
  get '/editProfile' => 'users#editprofile'
  get '/myGames' => 'users#mygames', :as => 'my_games'
  
  resources :sessions
  get "logout" => "sessions#destroy", :as => "logout"
  get "login" => "sessions#new", :as => "login"
  root :to => 'sessions#new'

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
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
