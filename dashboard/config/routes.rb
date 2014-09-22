Refinery::Core::Engine.routes.draw do
  namespace :admin, :path => Refinery::Core.backend_route do
    get 'dashboard', :to => 'dashboard#index', :as => :dashboard
    get 'dump_database', to: 'dashboard#dump_database'
  end
end
