module Refinery
  module Core
    class Authenticator

      class << self
        def enabled?
          true
        end

        def refinery_user?(current_refinery_user)
          !!current_refinery_user && current_refinery_user.has_role?(:refinery)
        end

        def just_installed?
          Refinery::Role[:refinery].users.empty?
        end
      end

    end
  end
end
