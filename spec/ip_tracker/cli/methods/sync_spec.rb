require 'spec_helper'
require 'ip_tracker'

describe IpTracker::CLI do
  describe '#sync' do

    def stub_config(update=false)
      config = mock_config
      config.should_receive(:update).with(:pid, 34) if update
      config.should_receive(:pid).and_return(nil)

      daemon = double(IpTracker::SyncDaemon, {})
      IpTracker::SyncDaemon.stub(:new) { daemon }
      daemon.should_receive(:run)
    end
    describe "start" do
      context "when there are no options" do
        let(:sync) { IpTracker::CLI.start(['sync']) }

        it "should call sync_daemon" do
          stub_config

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
          # stub_config(true)
        end
      end
    end

    describe "#stop" do
      context "when a pid is saved" do
        it "should send sigterm to the daemon and delete the pid" do

        end
      end

      it "should print an error when a pid file doesn't exist" do

      end
    end
  end
end
