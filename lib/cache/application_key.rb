module Cache
  class ApplicationKey
    # concerns
    include Cacheable

    # config
    set_cache prefix: 'application_key', key: 'hash', ttl: 0,
              schema: {host: Figaro.env.redis_host, port: Figaro.env.redis_port, db: Figaro.env.redis_db }

    # attributes
    attr_accessor *%w[id uuid key name application_id created_at updated_at hash]

    def initialize(params = {})
      set_params(params)
    end

  end
end
