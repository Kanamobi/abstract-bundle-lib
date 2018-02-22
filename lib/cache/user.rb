module Cache
  class User
    # concerns
    include Cacheable

    # config
    set_cache prefix: 'user'

    # attributes
    attr_accessor *%w[id email session_token phone picture_profile profile_type
                      status profile_id last_session session_expires_at recover_code
                      recover_expires_at profile address]

    def initialize(params = {})
      set_params(params)
    end

  end
end
