
require 'faraday_middleware'

module IpTracker
  class Client
    class HostTakenError < RuntimeError; end
    class TargetError < RuntimeError; end

    attr_accessor :host_token

    def register hostname
      connection = Faraday.new(:url => IpTracker::DEFAULT_LOCAL_TARGET) do |builder|
        builder.use Faraday::Request::JSON
        builder.use Faraday::Response::Rashify
        builder.use Faraday::Response::ParseJson

        builder.adapter :net_http
      end

      response = connection.post(IpTracker::HOSTS_PATH, name: hostname).body
      raise HostTakenError if response.code == 201
      raise TargetError if response.code == 200

      raise TargetError if response.id == nil
      @host_token = response.id
    end
  end
end
