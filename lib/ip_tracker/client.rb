
require 'ip_tracker/client/authentication'
require 'ip_tracker/client/connection'
require 'ip_tracker/client/errors'
require 'ip_tracker/client/request'

module IpTracker
  class Client
    attr_reader :http_adapter, :target_url

    def initialize
      @target_url = IpTracker::DEFAULT_LOCAL_TARGET
      @http_adapter = :net_http
    end

    # include Authentication
    include Connection
    include Request

    attr_accessor :host_token

    def register hostname
      response = post(IpTracker::HOSTS_PATH, :body => { name: hostname } )
      raise HostTakenError if response.code == 201
      raise TargetError if response.code == 200 || response.id == nil

      @host_token = response.id
    end

    def update host_id, attr, value
      response = put(IpTracker::HOSTS_PATH + "/#{host_id}", :body => {attr.to_sym => value})

      raise TargetError if response.code == 200 || response.send(attr) != value

      true
    end
  end
end
