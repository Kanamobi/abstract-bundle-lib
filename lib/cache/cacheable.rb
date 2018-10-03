module Cache
  # module to cache on redis
  module Cacheable
    extend ActiveSupport::Concern

    included do
      delegate 'dump', to: Marshal
      delegate 'build_struct', to: Cache::StructHelper
    end

    def cache!
      self.class.set(self)
    rescue Redis::CannotConnectError
      false
    end

    def serialized_to_cache
      marshaled? ? dump(self) : serialized.to_json
    end

    def marshaled?
      self.class.marshaled? || !self.class.serializable?
    end

    private

    def set_params(params)
      params.each do |key, value|
        value.is_a?(Hash) ? set_attr(key, build_struct(value)) : set_attr(key, value)
      end
    end

    def set_attr(attr, value)
      send("#{attr}=", value) if respond_to?("#{attr}=")
    end

    # class methods
    module ClassMethods
      attr_reader :repository

      def marshaled?
        repository.marshaled?
      end

      def parse(value)
        JSON.parse(value)
      end

      def from_cache(id)
        raise_not_in_cache unless cached?(id)
        marshaled? ?  Marshal.load(get(id)) : new(parse(get(id)))
      end

      def where_from_cache(search)
        cached_where(search).map { |id| from_cache(id) }
      end

      def serializable?
        ancestors.include?(Serializable)
      end

      def set_cache(params = {})
        @repository = Cache::Repository.new(name.underscore, params)
      end

      def get(value)
        repository.get(value)
      end

      def set(object)
        repository.set(object)
      end

      def del(value)
        repository.del(value)
      end

      def cached_where(search)
        repository.where(search)
      end

      def raise_not_in_cache
        raise Exceptions::Simple.build(message: 'not available in cache', field: 'id')
      end

      def cached?(value)
        repository.exists?(value)
      end

    end
  end
end
