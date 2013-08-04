module Blue
  module Roles
    extend ActiveSupport::Concern

    module ClassMethods
      def add_role(role)
        roles << role
      end

      def roles
        @roles ||= Set.new
      end

      def role? role_name
        roles.include? role_name
      end
    end
  end
end

