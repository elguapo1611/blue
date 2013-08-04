module Blue
  module Sudoers
    include Blue::Plugin

    def sudoers
      file '/etc/sudoers.d',
        :ensure  => :directory,
        :recurse => true,
        :purge   => true

      file '/etc/sudoers.d/README',
        :ensure => :present

      file '/etc/sudoers.d/blue',
        :ensure  => :present,
        :owner   => 'root',
        :group   => 'root',
        :mode    => '440',
        :content => template(File.join(File.dirname(__FILE__), '..', '..', 'templates', 'blue.sudoer'), binding)
    end

    setup do
      recipe :sudoers
    end
  end
end

