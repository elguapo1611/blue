module Blue
  module Plugins
    module Logrotate

      def logrotate(name, logs, options = {})
        logs = Array(logs).flatten.uniq.compact

        options = options.respond_to?(:to_hash) ? options.to_hash : {}
        options[:options] ||= [
          'daily',
          'missingok',
          'compress',
          'delaycompress',
          'sharedscripts'
        ]

        safename = name.to_s.gsub(/[^a-zA-Z]/, '')

        file "/etc/logrotate.d/#{safename}.blue.conf",
          :ensure => :present,
          :content => template(File.join(File.dirname(__FILE__), '..', '..', '..', 'templates', 'logrotate.conf.erb'), binding),
          :alias => "logrotate_#{safename}"

        package "logrotate",
          :ensure  => :installed
      end
    end
  end
end

