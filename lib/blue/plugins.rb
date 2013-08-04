module Blue
  module Plugins
    extend ActiveSupport::Concern

    def self.setup!
      Blue::Box.boxes.each do |box|
        box.plugins.each do |plugin|
          # puts "#{box.name}: Setup: #{plugin}"
          plugin.setup!(box)
        end
      end
    end

    module ClassMethods
      def add_plugin plugin
        plugins << plugin
      end

      def plugins &blk
        if block_given?
          yield
        else
          @plugins ||= Set.new
        end
      end

      def method_missing(name, opts = {}, &blk)
        require("blue/#{name}")
        module_name = "Blue::#{name.to_s.split('-').map(&:camelcase).join('::')}".constantize
        # puts "#{self}: Including: #{module_name}"
        send :include, module_name
        # puts "#{self}: Configuring: #{module_name}"
        configure name.to_s.split('-').join('_').intern => opts
        add_plugin module_name
      rescue LoadError
        super
      end
    end
  end
end

