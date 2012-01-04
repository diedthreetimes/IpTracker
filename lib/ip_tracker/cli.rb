require 'thor'

module IpTracker
  class CLI < Thor
    protected

    def get_option(option)
      value = ask("Please enter your #{option}:")
      raise Thor::Error, "You must enter a value for that field." if value.empty?
      value
    end

    def client
      @client ||= IpTracker::Client.new
    end

    def config
      @config ||= IpTracker::Config.new
    end
  end
end

require 'ip_tracker/cli/methods/register'
require 'ip_tracker/cli/methods/update'
require 'ip_tracker/cli/methods/sync'
