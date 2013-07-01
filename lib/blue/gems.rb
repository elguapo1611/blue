module Blue
  module Gems

    @@required_gems = [
      'bundler'
    ]

    def self.required_gems
      @@required_gems
    end

    def self.require(gem)
      @@required_gems << gem
    end
  end
end

