module IpTracker
  class Client
    class HostTakenError < RuntimeError; end
    class TargetError < RuntimeError; end
  end
end
