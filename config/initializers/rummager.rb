require 'gds_api/rummager'

def DapaasFrontend.search_client
  rummager_host = ENV["RUMMAGER_HOST"] || Plek.current.find('search')
  GdsApi::Rummager.new(rummager_host)
end
