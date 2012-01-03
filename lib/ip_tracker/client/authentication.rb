module IpTracker
  class Client
    module Authentication
      attr_accessor :auth_token
      attr_reader :user

      def login(username, password)
        response = post("#{IpTracker::USERS_PATH}/#{username}/tokens",
                        :body => { :password => password })

        raise TargetError if response.code == 200

        @user = username
        @auth_token = response.token
      end
    end
  end
end
