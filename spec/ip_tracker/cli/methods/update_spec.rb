require 'spec_helper'
require 'ip_tracker'

describe IpTracker::CLI do
  describe '#update' do
    let(:update) { IpTracker::CLI.start(['update','--ip','127.0.0.1']) }
    context "should display an error if" do
      it "no arguments are provided" do
        mock_config
        mock_client

        results = capture(:stderr) { IpTracker::CLI.start(['update']) }
        results.should match /No value provided/
      end

      # TODO: Automatically call register
      it "no hostid token present" do
        mock_config.should_receive(:host_token).and_return nil
        mock_client

        results = capture(:stdout) { update }
        results.should match /Please first register this computer./
      end
    end

    context "when a hostid token is present" do
      it "displays a failed message if client errors" do
        mock_client.should_receive(:update).
          with('token', :ip, '127.0.0.1') { raise IpTracker::Client::TargetError }
        mock_config.should_receive(:host_token).and_return('token')

        results = capture(:stdout) { update }
        results.should match /Update failed./
      end

      context "and client will succeed" do
        it "displays success" do
          mock_client.should_receive(:update).
            with('token', :ip, '127.0.0.1')
          mock_config.should_receive(:host_token).and_return('token')

          results = capture(:stdout) { update }
          results.should match /completed/
        end
      end
    end
  end
end
