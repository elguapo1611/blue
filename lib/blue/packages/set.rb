module Blue
  module Packages
    class Set
      attr_accessor :klass

      def initialize(klass = nil)
        @klass = klass
      end

      def config
        klass.config
      end
    end
  end
end

