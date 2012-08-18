require "spec_helper"

module Refinery
  describe "dashboard" do
    refinery_login_with :refinery

    describe "quick tasks" do
      describe "buttons" do
        before { visit refinery.admin_dashboard_path }

        specify 'quick_tasks heading' do
          page.should have_content(::I18n.t('quick_tasks', :scope => 'refinery.admin.dashboard.index'))
        end

        specify 'add a new page' do
          # add new page
          page.should have_content(::I18n.t('add_a_new_page', :scope => 'refinery.admin.dashboard.actions'))
          page.should have_selector("a[href='#{refinery.new_admin_page_path}']")
        end

        specify 'update a page' do
          # update page
          page.should have_content(::I18n.t('update_a_page', :scope => 'refinery.admin.dashboard.actions'))
          page.should have_selector("a[href='#{refinery.admin_pages_path}']")
        end

        if defined? Refinery::Resource
          specify 'upload a resource' do
            # upload file
            page.should have_content(::I18n.t('upload_a_file', :scope => 'refinery.admin.dashboard.actions'))
            page.should have_selector("a[href*='#{refinery.new_admin_resource_path}']")
          end
        end


        if defined? Refinery::Image
          specify 'upload an image' do
            # upload image
            page.should have_content(::I18n.t('upload_a_image', :scope => 'refinery.admin.dashboard.actions'))
            page.should have_selector("a[href*='#{refinery.new_admin_image_path}']")
          end
        end
      end
    end

    describe "latest activity" do
      before do
        3.times do |n|
          User.create :username => "ugisozols#{n}",
                      :email => "ugisozols#{n}@example.com",
                      :password => "ugisozols #{n}"
        end
        3.times { |n| Page.create :title => "Refinery CMS #{n}" }
      end

      it "shows created tracked objects" do
        visit refinery.admin_dashboard_path

        page.should have_content("Latest Activity")
        3.times { |n| page.should have_content("Ugisozols#{n} user was added") }
        3.times { |n| page.should have_content("Refinery cms #{n} page was added") }
      end

      # see https://github.com/resolve/refinerycms/issues/1673
      it "uses proper link for nested pages" do
        # we need to increase updated_at because dashboard entries are sorted by
        # updated_at column and we need this page to be at the top of the list
        nested = Page.last.children.new :title => 'Nested Page'
        nested.updated_at = Time.now + 10.seconds
        nested.save!

        visit refinery.admin_dashboard_path

        page.should have_selector("a[href='#{refinery.edit_admin_page_path(nested.uncached_nested_url)}']")
      end
    end
  end
end