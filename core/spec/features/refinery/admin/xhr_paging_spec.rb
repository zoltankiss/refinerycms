require "spec_helper"

module Refinery
  describe "Crudify" do
    # refinery_login_with :refinery_superuser

    describe "xhr_paging", :js => true do
      let!(:images) {
        [
          FactoryGirl.create(:image, :created_at => Time.zone.now),
          FactoryGirl.create(:alternate_image, :created_at => Time.zone.now - 1.day)
        ]
      }
      before do
        Refinery::Image.count.should == 2
        Admin::ImagesController.should_receive(:xhr_pageable?).
                               at_least(1).times.and_return(xhr_pageable)
        Images.stub(:preferred_image_view).and_return(:list)
        Image.stub(:per_page).and_return(1)
      end

      describe 'when set to true' do
        let(:xhr_pageable) { true }
        it 'should perform ajax paging of index' do
          visit refinery.admin_images_path

          expect(page).to have_selector('li.record', :count => 1)
          expect(page).to have_content(images.first.title)

          within '.pagination' do
            click_link '2'
          end

          expect(page.evaluate_script('jQuery.active')).to eq(1)
          expect(page).to have_content(images.last.title)
        end
      end

      describe 'set to false' do
        let(:xhr_pageable) { false }
        it 'should not perform ajax paging of index' do
          visit refinery.admin_images_path

          expect(page).to have_selector('li.record', :count => 1)
          expect(page).to have_content(images.first.title)

          within '.pagination' do
            click_link '2'
          end

          expect(page.evaluate_script('jQuery.active')).to eq(0)
          expect(page).to have_content(images.last.title)

        end
      end
    end
  end

end
