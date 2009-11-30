module StylesheetsHelper
  def sassify(str = nil, &block)
    sass_content = str || capture(&block)
    
    content_for(:stylesheets, content_tag(:style,Sass::Engine.new(sass_content).render, :type => "text/css" ))
  end
end