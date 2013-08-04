module Blue
  module Plugin
    extend ActiveSupport::Concern

    module ClassMethods
      def setup &blk
        @setup = blk
      end

      def setup! klass
        klass.class_eval(&@setup) if @setup
      end
    end

    included do
      extend ActiveSupport::Concern
    end
  end
end

