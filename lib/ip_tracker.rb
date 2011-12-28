require "ip_tracker/version"

module IpTracker
  DEFAULT_CONFIG_PATH  = '~/.ip_tracker'
  DEFAULT_LOCAL_TARGET = 'http://ipme.herokuapp.com'
  HOSTS_PATH           = '/hosts'
end

require 'ip_tracker/config'
require 'ip_tracker/cli'
require 'ip_tracker/client'
