module IpTracker
  class Client
    module Request
      def post(path, options={})
        request(:post, path, options)
      end

      def put(path, options={})
        request(:put, path, options)
      end

      private

      def request(action, path, options)
        response = connection.send(action, path) do |request|
          request.body = options[:body] if options[:body]
        end

        response.body
      end
    end
  end
end
