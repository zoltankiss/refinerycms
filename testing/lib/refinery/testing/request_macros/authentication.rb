module Refinery
  module Testing
    module RequestMacros
      module Authentication
        def refinery_login_with(*roles)
          roles = handle_deprecated_roles! roles
          let(:controller_permission) { true }
          let!(:logged_in_user) do
            user = mock 'Refinery::User', :username => 'Joe Fake'

            roles.each do |role|
              user.should_receive(:has_role?).
                   any_number_of_times.with(role).and_return true
            end
            if roles.exclude? :superuser
              user.should_receive(:has_role?).
                   any_number_of_times.with(:superuser).and_return false
            end

            user
          end

          before do
            Core::Authenticator.stub(:just_installed?).and_return false
            Core::Authenticator.stub(:refinery_user?).and_return true
            Core::Authenticator.stub(:enabled?).and_return false

            #login_as logged_in_user, :scope => :refinery_user
          end
        end

        def login_refinery_user
          Refinery.deprecate(:login_refinery_user, :when => '2.2', :replacement => 'refinery_login_with :refinery')
          refinery_login_with(:refinery_user)
        end

        def login_refinery_superuser
          Refinery.deprecate(:login_refinery_superuser, :when => '2.2', :replacement => 'refinery_login_with :refinery, :superuser')
          refinery_login_with(:refinery_superuser)
        end

        def login_refinery_translator
          Refinery.deprecate(:login_refinery_translator, :when => '2.2', :replacement => 'refinery_login_with :refinery, :translator')
          refinery_login_with(:refinery_translator)
        end

        private
        def handle_deprecated_roles!(*roles)
          mappings = {
            :user => [],
            :refinery_user => [:refinery],
            :refinery_superuser => [:refinery, :superuser],
            :refinery_translator => [:refinery, :translator]
          }
          mappings[roles.first] || roles
        end
      end
    end
  end
end
