class UnifiedSearchResultsPresenter

  def initialize(search_response)
    @search_response = search_response
  end

  def spelling_suggestion
    if search_response["suggested_queries"]
      search_response["suggested_queries"].first
    end
  end

  def result_count
    search_response["total"]
  end

  def results
    search_response["results"].map do |result|
      SearchResult.new(result)
    end
  end

  private

  attr_reader :search_response

end
