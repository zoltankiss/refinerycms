module Refinery
  class UserGenerator < Rails::Generators::Base

    source_root File.expand_path('../templates', __FILE__)

    def generate_refinery_initializer
      template "config/initializers/refinery/user.rb.erb",
               File.join(destination_root, "config", "initializers", "refinery", "user.rb")
    end
  end
end
