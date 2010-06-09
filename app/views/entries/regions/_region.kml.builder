xml.Placemark do
  xml.name(name)
  xml.styleUrl('#region')
  xml.LineString do
    xml.tessellate(1)
    xml.coordinates(region.coordinates)
  end
end
