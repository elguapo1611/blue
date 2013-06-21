module Blue
  module Gems

    @@required_gems = [
      'bundler',
      'shadow_puppet',
      'blue',
      'rake',
      'builder'
    ]

    def self.required_gems
      @@required_gems
    end

    def self.require(gem)
      @@required_gems << gem
    end
  end
end

