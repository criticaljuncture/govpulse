xml.instruct!
xml.kml(:xmlns => "http://www.opengis.net/kml/2.2") do
  xml.Document do
    xml.name("Regions for #{@entry.title}")
    xml.Style(:id => 'region') do
      xml.PolyStyle do
        xml.color('1A0000FF')
        xml.fill(1)
        xml.outline(1)
      end
    end
    
    @regions.each_with_index do |region, i|
      xml << render(:partial => "region", :locals => {:region => region, :name => "Region #{i+1}"})
    end
  end
end