module Refinery
  module Admin
    class CoreController < ::Refinery::AdminController
      def update_plugin_positions
        refinery_user.update_plugin_positions(params[:menu])
        render :nothing => true
      end
    end
  end
end
