require 'blue'

# This class/file represents a machine.

# Both the filename, and the class's name are relevant.
# Your server's hosname probably isn't some.hostname.com
# So, rename this file, and the classname below.

class SomeHostnameCom < Blue::Box

  # hostname change-me
  # external_ip 123.234.345.456
  # internal_ip 123.234.345.456 # required if you have more than one hoste

  # Blue modules get included like so:

  # include Blue::Redis
  # include Blue::Monit

  # That should really be all you need to do in here.
end

#
# Have multiple machines? I bet you do!
# Copy this file and change things accordingly.
#

