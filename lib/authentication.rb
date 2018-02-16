module Authentication
  # Authentication module contains all business class to manage the application authentication
  class Applicatation 
    include Exceptional

    delegate 'from_cache', 'cached?', to: Cache::ApplicationKey

    attr_reader *%w(app_key auth decoded)

    def initialize(auth)
      @auth = auth
    end

    def authenticate
      check
      decode
      authorize
      app_key
    end

    protected

    def check
      raise_unauthorized if auth.blank?
    end

    def decode
      @decoded = Base64.strict_decode64(auth.split(' ').last)
    end

    def authorize
      raise_unauthorized unless cached?(decoded)
      @app_key = from_cache(decoded)
    end

    def raise_unauthorized
      self.class.raise_simple(:auth, 'exceptions.unauthorized')
    end
  end
end
