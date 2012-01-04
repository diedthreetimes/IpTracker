require 'spec_helper'
require 'ip_tracker'

describe IpTracker::SyncDaemon do
  describe "#run" do
    let(:run) { IpTracker::SyncDaemon.new( runs: 5, sleep: 1 ).run }
    let(:mock_ip) { "127.0.0.1" }

    it "should update the ip exactly once" do
      UDPSocket.should_receive(:open).exactly(6).times.and_return(mock_ip)

      mock_config.should_receive(:host_token).and_return(6)
      mock_client.should_receive(:update).with(6, :ip,  mock_ip)

      results = capture(:stdout) { run }
      results.should match /process started/
      results.should_not match /error/
    end

    it "should degrade gracefully upon error" do
      UDPSocket.should_receive(:open).exactly(6).times.and_return(mock_ip)

      mock_config.should_receive(:host_token).at_least(1).times.and_return(6)
      mock_client.should_receive(:update).at_least(1).times.with(6, :ip, mock_ip) { raise IpTracker::Client::TargetError }

      results = capture(:stdout){ run }
      results.should match /error/
    end
  end
end
