require 'blue/template'
require 'blue/config'
require 'blue/plugins'
require 'blue/roles'

module Blue
  class Box < Blue::AbstractManifest

    include Blue::Template

    def self.inherited(klass)
      super # or else
      register(klass)
      klass.class_eval do
        include Blue::Config
        include Blue::Roles
        include Blue::Plugins
        add_role :ruby

        plugins do
          database_config
          sudoers
          ntpd
          iptables
        end

        include Blue::Packages::Manager
        include Blue::Packages::Os

        # import 'plugins/logrotate'
        # import 'plugins/unattended_upgrades'
      end
    end

    def config
      self.class.config
    end

    def blue_user
      group 'blue',
        :ensure => :present

      user 'blue',
        :ensure  => :present,
        :home    => "/home/blue",
        :shell   => "/bin/bash",
        :gid     => 'blue',
        :require => group('blue')

      [Blue::Box.log_path, Blue::Box.pids_path].each do |pth|
        file pth,
          :owner => Blue.config.user,
          :group => 'blue',
          :mode  => '770'
      end
    end
    recipe :blue_user

    module ClassMethods
      def current!
        @current = true
      end

      def current?
        @current
      end

      def current
        boxes.detect(&:current?)
      end

      def register(klass)
        boxes << klass
        true
      end

      def boxes
        @@boxes ||= Set.new
      end

      def load!
        Dir.glob("#{Blue::Box.rails_root}/config/blue/#{Blue.env}/*.rb").each do |rb|
          require rb
        end
      end

      def hostname(name = nil)
        @hostname ||= (name || raise(StandardError, "Thou shalt configure a hostname for #{self}"))
      end

      def external_interface
        Blue.config.networking.external_interface
      end

      def internal_interface
        if Blue.single_host?
          'lo'
        else
          Blue.config.networking.internal_interface || :eth1
        end
      end

      def all_interfaces
        [external_interface, internal_interface, 'lo'].uniq
      end

      def external_ip(addr = nil)
        @external_ip ||= addr || raise(StandardError, "Thou shalt configure an external_ip for #{self}")
      end

      def internal_ip(addr = nil)
        @addr ||= addr
        if @addr.blank? && Blue.multi_host?
          raise(StandardError, "Thou shalt configure an internal_ip for #{self}")
        end
        @addr ||= '127.0.0.1'
        @addr
      end

      def cap_user_ip
        [Blue.config.user, external_ip].join('@')
      end

      def migrations!
        @migrations = true
      end

      def migrations?
        @migrations.present?
      end

      def rails_root
        @@rails_root ||= `pwd`.strip #File.join(current_release_dir.split('/')[0..3] + ['current'])
      end

      def rails_current
        @@rails_current ||= File.join(current_release_dir.split('/')[0..3] + ['current'])
      end

      def current_release_dir
        @@current_release_dir ||= `pwd`.strip
      end

      def shared_path
        @@shared_path ||= "/u/apps/#{Blue.config.application}/shared/"
      end

      def log_path
        @@log_path ||= shared_path + "log/"
      end

      def pids_path
        @@pids_path ||= shared_path + "pids/"
      end

      def gem_path
        @gem_path ||= Bundler.load.specs.detect{|s| s.name == 'blue' }.try(:full_gem_path)
      end

      def iptables_rules
        @iptables_rules ||= Set.new
      end
    end

    extend ClassMethods
  end
end

