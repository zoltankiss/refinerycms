require "spec_helper"

module Refinery
  describe "site bar" do
    # refinery_login_with :refinery_user

    it "have logout link" do
      visit refinery.admin_dashboard_path

      page.should have_content("Log out")
      page.should have_selector("a[href='/refinery/logout']")
    end

    context "when in backend" do
      before { visit refinery.admin_dashboard_path }

      it "have a 'switch to your website button'" do
        page.should have_content("Switch to your website")
        page.should have_selector("a[href='/']")
      end

      it "switches to frontend" do
        expect { click_link "Switch to your website" }.to change {
          page.current_path
        }.from(refinery.admin_dashboard_path).to(refinery.root_path)
      end
    end

    context "when in frontend" do
      before do
        # make a page in order to avoid 404
        FactoryGirl.create(:page, :link_url => "/")

        visit refinery.root_path
      end

      it "have a 'switch to your website editor' button" do
        page.should have_content("Switch to your website editor")
        page.should have_selector("a[href='/refinery']")
      end

      it "switches to backend" do
        expect { click_link "Switch to your website editor" }.to change {
          page.current_path
        }.from(refinery.root_path).to(refinery.admin_root_path)
      end
    end
  end
end
