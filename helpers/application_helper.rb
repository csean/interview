module ApplicationHelper
  COORDINATES = [
                  { lat: 61.582195, lng: -149.443512 },
                  { lat: 44.775211, lng: -68.774184 },
                  { lat: 25.891297, lng: -97.393349 },
                  { lat: 45.787839, lng: -108.502110 },
                  { lat: 35.109937, lng: -89.959983 }
                ]

  def addresses(other_address: '1600 Pennsylvania Avenue NW Washington, D.C. 20500')
    comparison = Address.new(full_address: other_address)
    COORDINATES.each_with_object([]) do |cords, arr|
      address = Address.new(cords)
      address.miles_to(comparison)
      arr << address
    end.sort
  end
end
