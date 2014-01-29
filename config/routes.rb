DapaasFrontend::Application.routes.draw do
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root :to => 'root#index'

  [:blog, :news, :events, :partners, :reports].each do |section|
    section_slug = section.to_s.dasherize
    get "dapaas-#{section_slug}", as: "#{section}_section", to: "root##{section}_list", :section => section_slug

    get "dapaas-#{section_slug}/module", as: "#{section}_list_module", to: "root##{section}_list_module", :section => section_slug

    get "dapaas-#{section_slug}/:slug", as: "#{section}_article", to: "root##{section}_article", :section => section_slug

    get "dapaas-#{section_slug}/:slug/module", as: "#{section}_module", to: "root##{section}_module", :section => section_slug

    get "dapaas-#{section_slug}/:slug/badge", as: "#{section}_badge", to: 'root#badge', :section => section_slug
  end
  
  get ":slug", as: "page", to: 'root#page'
end
