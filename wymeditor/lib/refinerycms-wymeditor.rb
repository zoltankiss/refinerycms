require 'refinerycms-core'

module Refinery

  module Wymeditor
    class << self
      attr_accessor :root
      def root
        @root ||= Pathname.new(File.expand_path('../../', __FILE__))
      end
    end

    class Engine < ::Rails::Engine
      isolate_namespace ::Refinery

      config.autoload_paths += %W( #{config.root}/lib )

      # Register the plugin
      config.after_initialize do
        ::Refinery::Plugin.register do |plugin|
          plugin.pathname = root
          plugin.name = 'refinery_wymeditor'
          plugin.class_name = 'RefineryWymeditorEngine'
          plugin.version = ::Refinery.version
          plugin.hide_from_menu = true
          plugin.always_allow_access = true
          plugin.menu_match = /refinery\/(refinery_wymeditor)$/
        end
      end

      initializer "refinery.wymeditor.assets.precompile" do |app|
         app.config.assets.precompile += ["wymeditor/lang/*", "wymeditor/skins/refinery/*", "wymeditor/skins/refinery/**/*"]
      end
    end
  end

end

::Refinery.engines << 'wymeditor'
