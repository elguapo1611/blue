module Blue
  module Iptables
    class Rule
      attr_accessor :direction, :interface, :options

      def initialize(direction, interface, options = {})
        @direction = direction
        @interface = interface
        @options   = options
      end

      def to_s
        [
          rule,
          interface_flag + ' ' + interface.to_s,
          "-p tcp",
          source,
          desination_ip,
          destination_port,
          # options.delete(:extras),
          "-j ACCEPT"
        ].compact.join(' ')
      end

    private

      def input?
        direction == :input
      end

      def output?
        direction == :output
      end

      def rule
        "-A #{direction.to_s.upcase}"
      end

      def interface_flag
        if input?
          "-i"
        elsif output?
          "-o"
        end
      end

      def source
        if options[:source_ip]
          "-s #{options[:source_ip]}"
        end
      end

      def desination_ip
        if options[:destination_ip]
          "-d #{options[:destination_ip]}"
        end
      end

      def destination_port
        if options[:destination_port]
          "--dport #{options[:destination_port]}"
        end
      end
    end
  end
end

