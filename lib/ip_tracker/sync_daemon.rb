require 'socket'
require 'looper'

module IpTracker
  class SyncDaemon
    include ::Looper

    attr_accessor :last_ip

    def initialize(config)
      @run = true
      @runs = config[:runs].nil? ? nil : config[:runs]
      @sleep = config[:sleep].nil? ? 60 : config[:sleep]
    end

    def run
      loopme(@sleep) do
        if @runs == 0
          @run = false
        elsif !@runs.nil?
          @runs -= 1
        end

        begin
          new_ip = local_ip

          if @last_ip != new_ip
            update_ip new_ip

            @last_ip = new_ip
          end
        rescue
          # TODO: Figure out what error is raised by start
          puts "Some terrible error occured"
          @run = false
        end
      end
    end

    def local_ip
      orig, Socket.do_not_reverse_lookup = Socket.do_not_reverse_lookup, true # turn off reverse DNS resolution temporarily

      UDPSocket.open do |s|
        s.connect '64.233.187.99', 1
        s.addr.last
      end
    ensure
      Socket.do_not_reverse_lookup = orig
    end


      def update_ip ip
      CLI.start( ['update', '--ip', ip] )
    end
  end
end
