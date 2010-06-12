xml.Placemark do
  xml.name(name)
  xml.styleUrl('#region')
  xml.Polygon do
    xml.tessellate(1)
    xml.outerBoundaryIs do
      xml.LinearRing do
        xml.coordinates(region.coordinates)
      end
    end
    if region.holes.present?
      region.holes.each do |hole|
        xml.innerBoundaryIs do
          xml.LinearRing do
            xml.coordinates(hole.coordinates)
          end
        end
      end
    end
  end
end
