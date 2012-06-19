Rails.application.routes.draw do
  begin
    require 'devise'
    devise_for :refinery_user,
               :class_name => Refinery::Core.user_class,
               :path => 'refinery/users',
               :controllers => { :registrations => 'refinery/users' },
               :skip => [:registrations],
               :path_names => { :sign_out => 'logout',
                                :sign_in => 'login',
                                :sign_up => 'register' }

    # Override Devise's other routes for convenience methods.
    devise_scope :refinery_user do
      get '/refinery/login', :to => "sessions#new", :as => :sign_in
      get '/refinery/logout', :to => "sessions#destroy", :as => :sign_out
      get '/refinery/users/register' => 'users#new', :as => :sign_up
      post '/refinery/users/register' => 'users#create', :as => :sign_up
    end
  rescue RuntimeError => exc
    if exc.message =~ /ORM/
      # We don't want to complain on a fresh installation.
      if (ARGV || []).exclude?('--fresh-installation')
        puts "---\nYou can safely ignore the following warning if you're currently installing Refinery as Devise support files have not yet been copied to your application:\n\n"
        puts exc.message
        puts '---'
      end
    else
      raise exc
    end
  end

  namespace :admin, :path => 'refinery' do
    resources :users, :except => :show
  end
end
