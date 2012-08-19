module Refinery
  module Admin
    class CoreController < ::Refinery::AdminController

      def update_plugin_positions
        params[:menu].each_with_index do |plugin_name, index|
          current_refinery_user.plugins.where(:name => plugin_name).
                                update_all(:position => index)
        end
        render :nothing => true
      end

    end
  end
end
