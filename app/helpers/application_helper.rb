# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def set_content_for(name, content = nil, &block)
    ivar = "@content_for_#{name}"
    instance_variable_set(ivar, nil)
    content_for(name, content, &block)
  end
  
  def title(text, options = {})
    options.symbolize_keys!
    
    set_content_for :title, strip_tags(text)
    unless options[:body] == false
      set_content_for :precolumn, content_tag(:h1, text)
    end
  end
  
  def feed_autodiscovery(feed_url, title = 'RSS')
    content_for :feeds, content_tag(:link, nil, :rel => 'alternate', :type => 'application/rss+xml', :title => title, :href => feed_url)
  end
end
