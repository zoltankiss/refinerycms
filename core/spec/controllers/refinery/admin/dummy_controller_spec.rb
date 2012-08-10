require "spec_helper"

module Refinery
  module Admin
    class DummyController < Refinery::AdminController
      def index
        render :nothing => true
      end
    end
  end
end

module Refinery
  module Admin
    describe DummyController, :type => :controller do
      context "as refinery user" do
        refinery_login_with :refinery

        context "with permission" do
          let(:controller_permission) { true }
          it "allows access" do
            controller.should_not_receive :error_404
            get :index
          end
        end

        context "without permission" do
          let(:controller_permission) { false }
          it "denies access" do
            controller.should_receive :error_404
            get :index
          end
        end

        describe "force_ssl" do
          let(:force_ssl) { false }

          before do
            Core.stub(:force_ssl).and_return force_ssl
          end

          context 'is true' do
            let(:force_ssl) { true }

            it "so HTTPS is used" do
              # A routing error is raised because the route doesn't exist.
              expect {
                get :index
              }.to raise_exception ActionController::RoutingError
            end
          end

          context 'is false' do
            let(:foce_ssl) { false }

            it "so standard HTTP is used" do
              get :index

              response.should_not be_redirect
            end
          end
        end
      end
    end
  end
end