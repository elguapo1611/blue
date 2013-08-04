module Blue
  module Packages
    module Os
      include Blue::Packages

      def self.packages
        %w(
          g++ gcc make libc6-dev patch openssl ca-certificates libreadline6
          libreadline6-dev curl zlib1g zlib1g-dev libssl-dev libyaml-dev
          libxml2-dev libxslt1-dev autoconf libc6-dev
          libgdbm-dev libncurses5-dev automake libtool bison pkg-config libffi-dev
          git-core
        )
      end

      def self.templates
        Blue::Box.gem_path + "/templates/sources.list"
      end

      def self.commands
        "sudo mv /tmp/sources.list /etc/apt/sources.list"
      end
    end
  end
end

