require 'spec_helper'
require 'ip_tracker'

describe IpTracker::SyncDaemon do
  describe "#run" do
    let(:run) { IpTracker::SyncDaemon.new( runs: 5, sleep: 1 ).run }
    let(:mock_ip) { "127.0.0.1" }

    it "should update the ip exactly once" do
      UDPSocket.should_receive(:open).exactly(6).times.and_return(mock_ip)

      IpTracker::CLI.should_receive(:start).with(['update', '--ip', mock_ip])

      results = capture(:stdout) { run }
      results.should match /process started/
    end

    it "should degrade gracefully upon error" do
      # run
    end
  end
end
