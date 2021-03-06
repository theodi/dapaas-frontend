require 'artefact_retriever'

class RootController < ApplicationController
  slimmer_template :dapaas

  def action_missing(name, *args, &block)
    if name.to_s =~ /^(.*)_list_module$/
      list_module(params)
    elsif name.to_s =~ /^(.*)_list$/
      list(params)
    elsif name.to_s =~ /^(.*)_article$/
      article(params)
    else
      super
    end
  end

  def index
    @section = content_api.section("dapaas-home")
    render "section/section"
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

  def reports_list
    list(params, {order_by: "name"}, Proc.new { |artefacts| artefacts.sort_by!{|x| Date.parse(x.created_at) }.reverse! })
  end

  def events_list
    sort_events = Proc.new { |artefacts|
      artefacts.reject!{|x| Date.parse(x.details.start_date || x.details.date) < Date.today}
      artefacts.sort_by!{|x| Date.parse(x.details.start_date || x.details.date)}
    }

    list(params, {}, sort_events)
  end

  def news_list
    news_artefacts = Proc.new { |artefacts|
      artefacts += content_api.with_tag("blog").results
      artefacts.sort_by!{|x| x.created_at}.reverse!
      artefacts
    }

    list(params, {}, news_artefacts)
  end

  def list_module(params)
    @section = params[:section].parameterize
    @artefact = content_api.latest("tag", params[:section])
    @title = params[:section].humanize.capitalize
    slimmer_template "minimal"
    begin
      # Use a specific template if present
      render "list_module/#{params[:section]}", layout: 'minimal'
    rescue
      render "list_module/list_module", layout: 'minimal'
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

  def list(params, options = {}, proc = nil)
    @section = params[:section].parameterize
    @artefacts = content_api.with_tag(params[:section].singularize, options).results
    @artefacts = proc.call(@artefacts) unless proc.nil?
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

  def api_domain
    Plek.current.find("contentapi")
  end

end
