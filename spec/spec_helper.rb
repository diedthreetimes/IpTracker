require 'rubygems'
require 'bundler/setup'

require 'ip_tracker'

require 'webmock/rspec'

RSpec.configure do |config|

end

def fixture_path
  File.expand_path("../fixtures", __FILE__)
end

def fixture(file)
  File.new(fixture_path + '/' + file)
end

def capture(*streams)
  streams = [*streams]
  begin
    streams.each { |stream|
      stream = stream.to_s
      eval "$#{stream} = StringIO.new"
    }

    yield

    result = streams.map { |stream|
      eval("$#{stream}").string
    }.inject(:+)
  ensure
    streams.each { |stream|
      eval("$#{stream} = #{stream.upcase}")
    }
  end

  result
end


def mock_client(stubs={})
  client = double(IpTracker::Client, stubs)
  IpTracker::Client.stub(:new) { client }
  client
end

def mock_config(stubs={})
  config = double(IpTracker::Config, stubs)
  IpTracker::Config.stub(:new) { config }
  config
end

