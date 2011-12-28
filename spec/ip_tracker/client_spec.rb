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
      else
        "register_failure.txt"
      end
    stub_request(:post, "http://ipme.herokuapp.com/hosts").
          with(:body => {:hostname => 'foo'}).
          to_return(fixture(fixture_file))
  end


  describe "#register" do

    context "when successful" do

      it "sets and returns the token" do
        stub_register(:success)

        host_token = subject.register 'foo'
        subject.host_token.should == host_token
        host_token.should == "valid_host_token"
      end
    end

    it "raises an exception when failed" do
      stub_register(:failed)
      expect { subject.register('foo') }.to raise_error IpTracker::Client::TargetError
    end

    it "raises an exception when name taken" do
      stub_register(:no_name)
      expect { subject.register('foo') }.to raise_error IpTracker::Client::HostTakenError
    end
  end
end
