require 'blue'

module Blue
  require 'rails'

  class Railtie < Rails::Railtie
    rake_tasks { load "tasks/blue.rake" }
  end
end

