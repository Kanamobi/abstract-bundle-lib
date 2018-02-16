module Cache
  class ApplicationKey
    # concerns
    include Cacheable

    # config
    set_cache prefix: 'application_key'

    # attributes
    attr_accessor *%w[id uuid key name application_id]

    def initialize(params = {})
      set_params(params)
    end

  end
end
