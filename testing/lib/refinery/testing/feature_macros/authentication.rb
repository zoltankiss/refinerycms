module Refinery
  class Role
    def self.[](foo)
      new
    end

    def users
      [FakeRefineryUser.new]
    end
  end
end
class FakeRefineryUser < Refinery::Core::AbstractUser
  def has_role?(role)
    %w(superuser refinery).include?(role.to_s)
  end

  def authorized_plugins
    Refinery::Plugins.registered.names
  end
end

module Refinery
  module Testing
    module FeatureMacros
      module Authentication
        def login_as(user, *args)
          true
        end

        def refinery_login_with(factory)
          let!(:logged_in_user) { FakeRefineryUser.new }

          before do
            ApplicationController.stub(:just_installed?).and_return(false)
            ApplicationController.stub(:refinery_user?).and_return(true)
            # login_as logged_in_user, :scope => :refinery_user
          end
        end
      end
    end
  end
end
