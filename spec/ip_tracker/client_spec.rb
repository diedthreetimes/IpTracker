require 'spec_helper'
require 'ip_tracker'

describe IpTracker::Client do
  def stub_register(status)
    fixture_file =
      case status
      when :success
        "register_success.txt"
      when :no_name
        "register_taken.txt"
      when :invalid
        "register_invalid.txt"
      else
        "register_failure.txt"
      end
    stub_request(:post, IpTracker::DEFAULT_LOCAL_TARGET + IpTracker::HOSTS_PATH).
      with(:body => {:name => "foo"}).
          to_return(fixture(fixture_file))
  end

  #TODO: Refactor target+hosts to be configurable
  describe "#register" do

    context "when successful" do

      it "sets and returns the token" do
        stub_register(:success)

        host_token = subject.register 'foo'
        subject.host_token.should == host_token
        host_token.should == 6
      end
    end

    context "raises an exception when" do

      it "failed" do
        stub_register(:failed)
        expect { subject.register('foo') }.to raise_error IpTracker::Client::TargetError
      end


      it "name taken" do
        stub_register(:no_name)
        expect { subject.register('foo') }.to raise_error IpTracker::Client::HostTakenError
      end

      it "response invalid" do
        stub_register(:invalid)
        expect { subject.register('foo') }.to raise_error IpTracker::Client::TargetError
      end
    end
  end
end
