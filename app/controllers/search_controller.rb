class SearchController < ApplicationController
  slimmer_template :dapaas

  DEFAULT_RESULTS_PER_PAGE = 50
  MAX_RESULTS_PER_PAGE = 100

  def perform
    @search_term = params[:q]

    search_response = content_api.search(@search_term)

    results = SearchResultsPresenter.new(search_response)
    @result_count = results.result_count
    @results = results.results
  end

  protected

    def search_client
      DapaasFrontend.search_client
    end

    def requested_result_count
      count = request.query_parameters["count"]
      count = count.nil? ? 0 : count.to_i
      if count <= 0
        count = DEFAULT_RESULTS_PER_PAGE
      elsif count > MAX_RESULTS_PER_PAGE
        count = MAX_RESULTS_PER_PAGE
      end
      count
    end

end
