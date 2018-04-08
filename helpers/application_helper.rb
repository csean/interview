module ApplicationHelper
  COORDINATES = [
                  { lat: 61.582195, lng: -149.443512 },
                  { lat: 44.775211, lng: -68.774184 },
                  { lat: 25.891297, lng: -97.393349 },
                  { lat: 45.787839, lng: -108.502110 },
                  { lat: 35.109937, lng: -89.959983 }
                ]

  def address_list
    COORDINATES.each_with_object([]) do |cords, addresses|
      addresses << Address.new(cords)
    end
  end
end
