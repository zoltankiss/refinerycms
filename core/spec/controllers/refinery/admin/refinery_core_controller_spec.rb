require 'spec_helper'

module Refinery
  module Admin
    describe CoreController do
      refinery_login_with :refinery

      let(:plugins) do
        Refinery::Plugins.registered.names.sort_by{rand}
      end

      context 'reordering' do
        before do
          user_plugins = mock('user plugins')
          plugins.each_with_index do |plugin, index|
            where = mock('where')
            where.should_receive(:update_all).with(:position => index)
            user_plugins.should_receive('where').with(:name => plugin).
                         and_return(where)
          end
          logged_in_user.should_receive(:plugins).exactly(plugins.length).times.
                         and_return(user_plugins)
        end

        it "updates the plugin positions" do
          post 'update_plugin_positions', :menu => plugins
        end
      end
    end
  end
end
