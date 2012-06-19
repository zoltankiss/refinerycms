require 'spec_helper'

module Refinery
  module Admin
    describe CoreController do
      refinery_login_with :refinery

      let(:current_user) { controller.refinery_user }

      it "updates the plugin positions" do
        plugins = %w[pages images resources]
        current_user.should_receive(:update_plugin_positions).with(plugins)

        post 'update_plugin_positions', :menu => plugins
      end
    end
  end
end
