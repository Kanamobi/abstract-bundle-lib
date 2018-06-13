module Search
  class Pagination
    attr_reader :search, :objects, :pagination

    def initialize(search, objects, page, per_page)
      @search = search
      @objects = objects
      paginate(page, per_page)
    end

    def paginate(page, per_page)
      @pagination = {
        current_page: page,
        per_page: per_page,
        total_objects: search.total_entries,
        total_pages: search.total_pages
      }
    end

    def as_json
      { objects: objects, pagination: pagination }
    end


  end
end