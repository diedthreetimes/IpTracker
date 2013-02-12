require'faraday_middleware'

module IpTracker
  class Client
    module Connection
      private

      def connection
        connection = Faraday.new(:url => target_url) do |builder|
          builder.use FaradayMiddleware::EncodeJson
          builder.use Faraday::Response::Rashify
          builder.use Faraday::Response::ParseJson, content_type: 'application/json'

          builder.adapter http_adapter
        end
      end
    end
  end
end
