require_relative 'geocoding'

class Address
  attr_accessor :lat, :lng, :full_address

  def initialize(lat: nil, lng: nil, full_address: nil)
    @lat = lat
    @lng = lng
    @full_address = full_address
    full_address.nil? ? set_address : set_lat_lng
  end

  def geocoded?
    !(lat.nil? || lng.nil?)
  end

  def reverse_geocoded?
    !full_address.nil?
  end

  private

  def set_address
    return if reverse_geocoded?
    @full_address = Geocoder.address([lat, lng])
  end

  def set_lat_lng
    return if geocoded?
    @lat, @lng = Geocoder.coordinates(full_address)
  end
end
