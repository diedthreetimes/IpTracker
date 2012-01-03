require'faraday_middleware'

module IpTracker
  class Client
    module Connection
      private

      def connection
        connection = Faraday.new(:url => target_url) do |builder|
          builder.use Faraday::Request::JSON
          builder.use Faraday::Response::Rashify
          builder.use Faraday::Response::ParseJson

          builder.adapter http_adapter
        end
      end
    end
  end
end
