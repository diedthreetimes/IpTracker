module IpTracker
  class CLI
    desc "update", "update IpMe with the specified IP"
    method_option :ip, :type => :string, :desc => "Which IP to update use", :required => true
    def update
      ip = options[:ip]
      host = config.host_token
      if host.nil?
        say "Please first register this computer."
      else
        say "Attempting to update ip.", :yellow

        client.update(host, :ip, ip)

        say "Update completed", :green
      end
    rescue IpTracker::Client::TargetError
      say "Update failed."
    end
  end
end
