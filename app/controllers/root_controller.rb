require 'artefact_retriever'

class RootController < ApplicationController
  slimmer_template :dapaas
  
  def action_missing(name, *args, &block)
    if name.to_s =~ /^(.*)_list$/
      list(params)
    elsif name.to_s =~ /^(.*)_article$/
      article(params)
    else
      super
    end
  end
  
  def index
    artefact = ArtefactRetriever.new(content_api, Rails.logger, statsd).
                  fetch_artefact('dapaas-home', nil, nil, nil)
    @publication = PublicationPresenter.new(artefact)
    render "content/page"
  end
  
  def page
    artefact = ArtefactRetriever.new(content_api, Rails.logger, statsd).
                  fetch_artefact(params[:slug], params[:edition], nil, nil)

    @publication = PublicationPresenter.new(artefact)
    respond_to do |format|
      format.html do
        begin
          # Use a specific template if present
          render "content/page-#{params[:slug]}.json"
        rescue
          render "content/page"
        end
      end
      format.json do
        redirect_to "#{api_domain}/#{params[:slug]}.json"
      end
    end
  end
  
  private
  
  def article(params)
    artefact = ArtefactRetriever.new(content_api, Rails.logger, statsd).
                  fetch_artefact(params[:slug], params[:edition], nil, nil)

    @publication = PublicationPresenter.new(artefact)
    respond_to do |format|
      format.html do
        begin
          render "content/#{@section}"
        rescue ActionView::MissingTemplate
          render "content/#{@publication.format}"
        end
      end
      format.json do
        redirect_to "#{api_domain}/#{params[:slug]}.json"
      end
    end
  end
  
  def list(params)
    @section = params[:section].parameterize
    @artefacts = content_api.with_tag(params[:section].singularize).results
    @artefacts = news_artefacts(@artefacts) if @section == "news"
    sort_events(@artefacts) if @section == "events"
    @title = params[:section].gsub('-', ' ').humanize.capitalize
    respond_to do |format|
      format.html do
        begin
          # Use a specific template if present
          render "list/#{params[:section]}"
        rescue
          render "list/list"
        end
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
  
  def sort_events(artefacts)
    artefacts.reject!{|x| Date.parse(x.details.start_date || x.details.date) < Date.today}
    artefacts.sort_by!{|x| Date.parse(x.details.start_date || x.details.date)}
  end
  
  def news_artefacts(artefacts)
    artefacts += content_api.with_tag("blog").results
    artefacts.sort_by!{|x| x.created_at}.reverse!
    artefacts
  end
  
  def api_domain
    Plek.current.find("contentapi")
  end
  
end