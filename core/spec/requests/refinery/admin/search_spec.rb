require "spec_helper"

module Refinery
  describe "search" do
    refinery_login_with :refinery

    context "when searched item exists" do
      describe "image extension" do
        let!(:image) { image_factory! }

        it "returns found image" do
          visit refinery.admin_images_path
          fill_in "search", :with => image.image_name.split(' ').first
          click_button "Search"

          within ".actions" do
            page.should have_selector("a[href$='#{image.image_name}']")
          end
        end
      end

      describe "resource extension" do
        let!(:resource) { resource_factory! }

        it "returns found resource" do
          visit refinery.admin_resources_path
          fill_in "search", :with => resource.file_name.split(' ').first
          click_button "Search"
          page.should have_content(resource.title)
        end
      end

      describe "page extension" do
        before { Page.create :title => "Ugis Ozols" }

        it "returns found page" do
          visit refinery.admin_pages_path
          fill_in "search", :with => "ugis"
          click_button "Search"
          page.should have_content("Ugis Ozols")
        end
      end
    end

    context "when searched item don't exist" do
      def shared_stuff
        fill_in "search", :with => "yada yada"
        click_button "Search"
        page.should have_content("Sorry, no results found")
      end

      describe "image extension" do
        it "returns no results" do
          visit refinery.admin_images_path
          shared_stuff
        end
      end

      describe "resource extension" do
        it "returns no results" do
          visit refinery.admin_resources_path
          shared_stuff
        end
      end

      describe "page extension" do
        it "returns no results" do
          visit refinery.admin_pages_path
          shared_stuff
        end
      end
    end
  end
end
