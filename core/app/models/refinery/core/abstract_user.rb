module Refinery
  module Core
    class AbstractUser
      include ActiveModel::Naming
      include ActiveModel::Conversion

      def authenticatable_salt
        'override me'
      end

      def has_role?(role)
        false
      end

      def authorized_plugins
        Refinery::Plugins.new
      end
    end
  end
end
