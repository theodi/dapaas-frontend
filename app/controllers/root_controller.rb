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
  end
  
  private
  
  def article(params)
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
  
  def list(params)
    @section = params[:section].parameterize
    @artefacts = content_api.with_tag(params[:section].singularize).results
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
  
end