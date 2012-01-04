module IpTracker
  class CLI
    desc "sync", "continuously sync the ip with IpMe"
    method_option :start, :type => :boolean, :desc => "Command start", :default => true
    method_option :stop, :type => :boolean, :desc => "Command stop", :default => false
    method_option :daemon, :aliases => ["b"], :default => false, :desc => "Run this as a daemon, only works with start"

    def sync
      command = options[:stop] ? :stop : :start
      daemonize = options[:daemon]

      case command
      when :start
        if config.pid
          say "IpMe is already running."
        else
          SyncDaemon.new.run


        end
      when :stop

      end

    end
  end
end
