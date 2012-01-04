require 'spec_helper'
require 'ip_tracker'

describe IpTracker::CLI do
  describe '#sync' do

    def stub_config(pid=nil)
      config = mock_config
      config.should_receive(:update).with(:pid, pid) if !pid.nil?
      config.should_receive(:pid).and_return(nil)
    end

    def stub_daemon
      daemon = double(IpTracker::SyncDaemon, {})
      IpTracker::SyncDaemon.stub(:new) { daemon }
      daemon.should_receive(:run)
    end
    describe "start" do
      context "when there are no options" do
        let(:sync) { IpTracker::CLI.start(['sync']) }

        it "should call sync_daemon" do
          stub_config
          stub_daemon

          sync
        end

        it "prints an error when a pid is saved" do
          mock_config.should_receive(:pid).and_return(343)
          IpTracker::SyncDaemon.should_not_receive(:new)

          results = capture(:stdout) { sync }
          results.should match /IpMe is already running./
        end
      end

      context "when daemonize is provided" do
        let(:sync) { IpTracker::CLI.start(['sync', '--start', '-d']) }

        it "should detach and store a pid" do
          stub_config(36)

          Process.should_receive(:fork).and_return(36)
          Process.should_receive(:respond_to?).with(:fork).and_return(true)
          Process.should_receive(:detach)

          results = capture(:stdout) { sync }
          results.should == ""

          #TODO: assert output is redirected to a file
        end
      end
    end

    describe "#stop" do
      let(:sync) { IpTracker::CLI.start(['sync', '--stop']) }
      context "when a pid is saved" do
        it "should send sigterm to the daemon and delete the pid" do
          mock_config.should_receive(:pid).at_least(1).times.and_return(36)
          Process.should_receive(:kill).with("TERM", 36)

          results = capture(:stdout) { sync }
          results.should match /killed/i
        end
      end

      it "should print a warning when a pid doesn't exist" do
        stub_config

        results = capture(:stdout) { sync }
        results.should match /no pid/i
      end
    end
  end
end
