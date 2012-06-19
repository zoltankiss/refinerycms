module Refinery
  module Testing
    module RequestMacros
      module Authentication
        def refinery_login_with(*roles)
          let(:logged_in_user) do
            user = stub 'User', :authorized_plugins => ::Refinery::Plugins.registered.names

            roles.each do |role|
              user.should_receive(:has_role?).any_number_of_times.with(role).and_return true
            end
            if roles.exclude?(:superuser)
              user.should_receive(:has_role?).with(:superuser).and_return false
            end

            user
          end

          before do
            # Refinery::AdminController.any_instance.stub(:current_refinery_user).
            #                           and_return(logged_in_user)
            # Refinery::AdminController.any_instance.stub(:just_installed?).
            #                           and_return false
            Refinery::AdminController.any_instance.stub(:refinery_user?).
                                      and_return roles.include?(:refinery)
          end
        end

        def login_refinery_user
          Refinery.deprecate(:login_refinery_user, :when => '2.2', :replacement => 'refinery_login_with :refinery')
          refinery_login_with(:refinery)
        end

        def login_refinery_superuser
          Refinery.deprecate(:login_refinery_superuser, :when => '2.2', :replacement => 'refinery_login_with :refinery, :superuser')
          refinery_login_with(:refinery, :superuser)
        end

        def login_refinery_translator
          Refinery.deprecate(:login_refinery_translator, :when => '2.2', :replacement => 'refinery_login_with :refinery, :translator')
          refinery_login_with(:refinery, :translator)
        end
      end
    end
  end
end
