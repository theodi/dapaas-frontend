class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  include Slimmer::Template
  
  def content_api
    content_api ||= GdsApi::ContentApi.new(
      Plek.current.find("contentapi"),
      CONTENT_API_OPTIONS
    )
  end
  
  def statsd
    statsd ||= Statsd.new("localhost").tap do |c|
      c.namespace = ENV['GOVUK_STATSD_PREFIX'].to_s
    end
  end
  
end
