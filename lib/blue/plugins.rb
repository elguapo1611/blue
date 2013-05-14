# require 'blue/plugins/ntpd'
# require 'blue/plugins/local_config'

module Blue
  module Plugins

    # Scour loaded gems for matches and require them.
    def self.init
      Gem.loaded_specs.values.map(&:name).select{|n| n.match("blue-")}.each do |plugin|
        require plugin
      end
    end
  end
end

Blue::Plugins.init

