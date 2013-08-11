module Blue
  module Logrotate
    include Blue::Plugin

    def self.default_options
      [
        'daily',
        'missingok',
        'compress',
        'delaycompress',
        'sharedscripts'
      ]
    end

    module ClassMethods
      def rotated_logs
        @rotated_logs ||= Set.new
      end

      def rotate_log(paths, options = {})
        paths = Array(paths).flatten.uniq.compact

        options[:options] ||= Blue::Logrotate.default_options

        rotated_logs << {
          :names   => paths.join(' '),
          :options => options
        }
      end
    end

    def logrotate
      package "logrotate",
        :ensure => :installed

      file "/etc/logrotate.d/blue.conf",
        :ensure  => :present,
        :content => template(File.join(File.dirname(__FILE__), '..', '..', 'templates', 'logrotate.conf.erb'), binding),
        :require => package('logrotate')
    end

    setup do
      recipe :logrotate

      rotate_log Blue::Box.log_path + Blue.env + ".log"
    end
  end
end

