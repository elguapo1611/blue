module Blue
  module Plugins
    module Apt

      def apt
        file "/etc/apt/sources.list.d/apt.list",
          :ensure  => :present,
          :mode    => '744',
          :content => template(File.join(File.dirname(__FILE__), '..', '..', '..', 'templates', 'apt.list'), binding)
      end

      def self.included(klass)
        klass.add_role(:apt)
        klass.class_eval do
          recipe :apt
        end
      end
    end
  end
end

