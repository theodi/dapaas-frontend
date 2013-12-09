module ApplicationHelper
  
  def module_block(section, publication)
  	begin
  		render :partial => "module/#{section.gsub('-', '_')}", :locals => { :section => section, :publication => publication }
    rescue ActionView::MissingTemplate
  	  render :partial => 'module/block', :locals => { :section => section, :publication => publication }
  	end
  end
  
end
