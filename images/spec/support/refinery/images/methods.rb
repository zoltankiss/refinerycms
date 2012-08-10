module Refinery
  module Images
    module Methods
      def image_factory(image = nil)
        image ||= Refinery.roots(:'refinery/images').
                           join 'spec/fixtures/beach.jpeg'

        Image.new :image => image
      end

      def image_factory!(image = nil)
        object = image_factory image
        object.save
        object
      end
    end
  end
end

RSpec.configure do |config|
  config.include Refinery::Images::Methods
end
