require 'spec_helper'
require 'ip_tracker'

describe IpTracker::Config do
  let(:path) { File.expand_path(IpTracker::DEFAULT_CONFIG_PATH) }
  let(:io) { StringIO.new }

  #  TODO refactor tests to use settings once configurable

  def stub_config_file(contents=nil)
    File.stub(:exists?).with(path) { contents ? true : false }
    YAML.stub(:load_file).with(path) { contents } if contents
    File.stub(:open).with(path, 'w').and_yield(io)
  end

  describe "#update" do
    context "when a .ip_tracker file doesn't exist" do
      it "creates the file and can add a new token" do
        expected_token = 'new_token'

        stub_config_file(nil)
        YAML.should_receive(:dump).with({"host_token" => expected_token}, io)

        config = IpTracker::Config.new
        config.update(:host_token, 'new_token')
        config.host_token.should == expected_token
      end
    end

    context "when a .ip_tracker file exists" do
      it "can update tokens in the .ip_tracker file" do
        expected_token = 'new_token'
        old_token = 'old_token'

        stub_config_file("host_token" => old_token)
        YAML.should_receive(:dump).with({"host_token" => expected_token}, io)

        config = IpTracker::Config.new
        config.host_token.should == old_token
        config.update(:host_token, 'new_token')
        config.host_token.should == expected_token
      end
    end
  end
end
