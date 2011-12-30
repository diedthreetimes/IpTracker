module IpTracker
  class CLI
    desc "register", "register this computer with IpMe"
    method_option :hostname, :type => :string, :desc => "What name to store this hoste under"
    def register
      unless config.host_token
        hostname = options[:hostname] || get_option(:hostname)

        say "Attempting to register this computer.", :yellow

        token = client.register(hostname)
        say "Registration completed.", :green
        config.update(:host_token, token)
      else
        say "This computer has already been registered."
      end
    rescue IpTracker::Client::TargetError
      say "Registration failed."
    rescue IpTracker::Client::HostTakenError
      say "You must enter a unique name."
    end
  end
end

