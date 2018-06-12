module Search
  class Serializer
    include ::AbstractBundle::Interface

    needs_implmentation :from_cache, :exists?

    attr_reader :object, :user_id, :serialized

    def initialize(user_id, object)
      @object = object
      @user_id = user_id
      @serialized = @object.serialized
      serialized
    end

    def serialize
      is_favorited = favorited?
      serialized['favorite_id'] = from_cache(favorite_key).favorite_id if is_favorited
      serialized['favorited'] = is_favorited
    end
    
    def favorite_key
      "#{user_id}|#{object.id.to_s}"
    end
    
    def favorited?
      exists?(favorite_key)
    end


  end
end