require "spec_helper"

module Refinery
  describe Admin::UsersController do
    refinery_login_with :refinery_superuser

    shared_examples_for "new, create, update, edit and update actions" do
      it "loads roles" do
        Role.should_receive(:all).once.and_return []
        get :new
      end

      it "loads plugins" do
        user_plugin = Plugins.registered.detect { |plugin| plugin.name == "refinery_users" }
        plugins = Plugins.new
        plugins << user_plugin
        plugins.should_receive(:in_menu).once.and_return [user_plugin]

        Plugins.should_receive(:registered).at_least(1).times.and_return plugins
        get :new
      end
    end

    describe "#new" do
      it "renders the new template" do
        get :new
        response.should be_success
        response.should render_template("refinery/admin/users/new")
      end

      it_should_behave_like "new, create, update, edit and update actions"
    end

    describe "#create" do
      it "creates a new user with valid params" do
        user = Core.user_class.new :username => "bob"
        user.should_receive(:save).once{ true }
        Core.user_class.should_receive(:new).once.with(instance_of(HashWithIndifferentAccess)){ user }
        post :create, :user => {}
        response.should be_redirect
      end

      it_should_behave_like "new, create, update, edit and update actions"

      it "re-renders #new if there are errors" do
        user = Core.user_class.new :username => "bob"
        user.should_receive(:save).once.and_return false
        Core.user_class.should_receive(:new).once.with(instance_of(HashWithIndifferentAccess)){ user }
        post :create, :user => {}
        response.should be_success
        response.should render_template("refinery/admin/users/new")
      end
    end

    describe "#edit" do
      it "renders the edit template" do
        logged_in_user.should_receive(:plugins).and_return []
        logged_in_user.should_receive(:can_edit?).with(logged_in_user).and_return true
        controller.should_receive(:find_user).at_least(1).times.and_return logged_in_user

        get :edit, :id => logged_in_user.id
        response.should be_success
        response.should render_template("refinery/admin/users/edit")
      end

      it_should_behave_like "new, create, update, edit and update actions"
    end

    describe "#update" do
      let(:additional_user) { FactoryGirl.create :refinery_user }
      it "updates a user" do
        logged_in_user.should_receive(:can_edit?).with(additional_user).and_return true
        Core.user_class.should_receive(:find).at_least(1).times{ additional_user }

        put "update", :id => additional_user.id.to_s, :user => {}
        response.should be_redirect
      end

      context "when specifying plugins" do
        it "won't allow to remove 'Users' plugin from self" do
          logged_in_user.should_receive(:can_edit?).with(logged_in_user).and_return true
          Core.user_class.should_receive(:find).at_least(1).times{ logged_in_user }
          put "update", :id => logged_in_user.id.to_s, :user => {:plugins => ["some plugin"]}

          flash[:error].should eq("You cannot remove the 'Users' plugin from the currently logged in account.")
        end
      end

      it_should_behave_like "new, create, update, edit and update actions"
    end
  end
end
