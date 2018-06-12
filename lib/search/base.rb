module Search
  # Base search class with basic methods
  class Base
    include ::AbstractBundle::Interface

    attr_reader 'results', 'params', 'query', 'search_params', 'page', 'user_id','per_page'

    needs_implementation 'build_search', 'make_search'

    def initialize(params, page, per_page, user_id = nil)
      @params = params
      @page = page
      @per_page = per_page
      @user_id = user_id
      setup_params
      build_search
      make_search
    end

    def setup_params
      @query = params.fetch(:query).blank? ? '*' : params[:query]
    end

    def serialize_with_favorite(results, serializer: Search::Serializer)
      results.map { |object| serializer.new(user_id, object).serialized }
    end

    private 

    def has_near_params
      params.key?(:lat) && params.key?(:lon) && params.key?(:range)
    end

    def add(*list)
      list.each { |attr| search_params[:where][attr] = params[attr] if params.key?(attr) }
    end

    def add_with_keys(where_key, param_key)
      search_params[:where][where_key] = params[param_key] if params.key?(param_key)
    end

    def add_with_keys_as_regex(where_key, param_key)
      search_params[:where][where_key] = /#{params[param_key]}/ if params.key?(param_key)
    end


  end
end
