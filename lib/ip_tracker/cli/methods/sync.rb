module IpTracker
  class CLI
    desc "sync", "continuously sync the ip with IpMe"
    method_option :start, :type => :boolean, :desc => "Command start", :default => true
    method_option :stop, :type => :boolean, :desc => "Command stop", :default => false
    method_option :daemon, :type => :boolean, :aliases => ["-d"], :default => false, :desc => "Run this as a daemon, only works with start"

    def sync
      command = options[:stop] ? :stop : :start
      daemonize = options[:daemon] && Process.respond_to?(:fork)

      case command
      when :start
        if config.pid
          say "IpMe is already running."
        else
          if daemonize
            pid = Process.fork do
              SyncDaemon.new.run
              Process.daemon
            end

            # TODO verify if detach and daemon work together
            config.update(:pid, pid)
            Process.detach(pid)
          else
            SyncDaemon.new.run
          end
        end
      when :stop
        if config.pid
          say "Killing #{config.pid}"

          Process.kill("TERM", config.pid)

          say "Killed"
        else
          say "No PID saved"
        end
      end

    end
  end
end
