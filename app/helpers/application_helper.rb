module ApplicationHelper
  
  def module_block(section, publication)
  	begin
  		render :partial => "module/#{section.gsub('-', '_')}", :locals => { :section => section, :publication => publication }
    rescue ActionView::MissingTemplate
  	  render :partial => 'module/block', :locals => { :section => section, :publication => publication }
  	end
  end
  
  def date_range(from_date, until_date)
    if from_date.to_date == until_date.to_date
     "#{from_date.strftime("%A %d %B %Y")}, #{from_date.strftime("%l:%M%P")} - #{until_date.strftime("%l:%M%P")}"
    else
     "#{from_date.strftime("%A %d %B %Y")} #{from_date.strftime("%l:%M%P")} - #{until_date.strftime("%A %d %B %Y")} #{until_date.strftime("%l:%M%P")}"
    end    
  end
  
  def upcoming_event?
    @publication.end_date.to_datetime > DateTime.now
  end
  
end
