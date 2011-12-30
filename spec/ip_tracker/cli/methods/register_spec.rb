require 'spec_helper'
require 'ip_tracker'

describe IpTracker::CLI do

  describe 'executable' do
    it 'should print usage' do
      `ipme`.should match /Tasks:/
    end
  end

  describe '#register' do
    context "when there is no hostid token" do
      def stub_client_and_config
        mock_client.should_receive(:register).with('foo') { 'token' }

        config = mock_config
        config.should_receive(:update).with(:host_token, 'token')
        config.should_receive(:host_token).and_return(nil)
      end

      context 'and no arguments are provided' do
        let(:register) { IpTracker::CLI.start(['register']) }

        it "asks for a new hostname" do
          stub_client_and_config
          $stdin.should_receive(:gets).and_return('foo')

          results = capture(:stdout) { register }
          results.should match /Please enter your hostname:/
        end

        context "displays an error if" do
          it "hostname is blank" do
            mock_config.should_receive(:host_token).and_return(nil)

            $stdin.should_receive(:gets).and_return('')
            results = capture(:stderr, :stdout) { register }
            results.should match /must enter a value/
            results.should_not match /success/
          end

          it "hostname is taken" do
            mock_config.should_receive(:host_token).and_return(nil)

            $stdin.should_receive(:gets).and_return('')
            results = capture(:stderr, :stdout) { register }
            results.should match /must enter a/
            results.should_not match /success/
          end
        end

      end

      context "and a hostname is provided" do
        let(:register) do
          IpTracker::CLI.start(["register", "--hostname", "foo"])
        end

        it "does not ask for hostnme" do
          stub_client_and_config
          $stdin.should_not_receive(:gets)
          results = capture(:stdout) { register }
          results.should match /Attempting to register/
        end

        context "and hostname will fail" do
          it "displays a failed message if host taken" do
            mock_client.should_receive(:register).
              with('foo') { raise IpTracker::Client::HostTakenError }
            mock_config.should_receive(:host_token).and_return(nil)

            results = capture(:stdout) { register }
            results.should match /You must enter a unique name./
          end

          it "displays a failed message if client errors" do
            mock_client.should_receive(:register).
              with('foo') { raise IpTracker::Client::TargetError }
            mock_config.should_receive(:host_token).and_return(nil)

            results = capture(:stdout) { register }
            results.should match /Registration failed./

          end
        end

        context "and hostname will succeed" do
          it "saves a hostid token and displays success" do
            stub_client_and_config

            results = capture(:stdout) { register }
            results.should match /completed/
          end
        end
      end
    end

    context "when there is a hostid token" do
      let(:register) { IpTracker::CLI.start(['register']) }
      it "should not ask for hostname and print a message" do
        mock_config.should_receive(:host_token).and_return('token')
        $stdin.should_not_receive(:gets)
        results = capture(:stdout) { register }
        results.should match /This computer has already been registered./
      end
    end
  end # register
end # CLI
