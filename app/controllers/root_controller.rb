require 'artefact_retriever'

class RootController < ApplicationController
  slimmer_template :dapaas
  
  def index
  end
  
  def news_list
    @section = "news"
    results = content_api.with_tag("news")
    @artefacts = results.results
    @title = "News"
    respond_to do |format|
      format.html do
        render "list/news"
      end
      format.json do
        redirect_to "#{api_domain}/with_tag.json?tag=#{params[:section].singularize}&role=dapaas"
      end
      format.atom do
        slimmer_template nil
        render "list/feed"
      end
    end
  end
  
  def news_article
    artefact = ArtefactRetriever.new(content_api, Rails.logger, statsd).
                  fetch_artefact(params[:slug], params[:edition], nil, nil)

    @publication = PublicationPresenter.new(artefact)
    respond_to do |format|
      format.html do
        begin
          # Use a specific template if present
          render "content/page-#{params[:slug]}"
        rescue
          render "content/page"
        end
      end
      format.json do
        redirect_to "#{api_domain}/#{params[:slug]}.json"
      end
    end
  end
  
end