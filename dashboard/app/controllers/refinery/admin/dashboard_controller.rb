require 'yaml_db_improved'

module Refinery
  module Admin
    class DashboardController < Refinery::AdminController
      def index
        @recent_inquiries = if Refinery::Plugins.active.find_by_name("refinerycms_inquiries")
          Refinery::Inquiries::Inquiry.latest(Refinery::Dashboard.activity_show_limit)
        else
          []
        end
      end

      def dump_database
        path = Rails.root.join('tmp/', "data#{SecureRandom.urlsafe_base64}.yml")
        SerializationHelper::Base.new(YamlDb::Helper).dump(path)
        send_data File.open(path).readlines.join("\n"), filename: 'data.txt'
      end
    end
  end
end
