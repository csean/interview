RSpec.describe Address do
  let(:full_address) { '1600 Pennsylvania Avenue NW Washington, D.C. 20500 U.S.' }
  let(:lat) { 40.181306 }
  let(:lng) { -80.265949 }

  describe 'geocoding' do
    subject(:address) { described_class.new(full_address: full_address) }

    let(:result) { [lat, lng] }

    it 'geocodes with Geocoder API' do
      expect(Geocoder).to receive(:coordinates).with(full_address).and_return result
      address
    end

    it 'is geocoded' do
      expect(address).to be_geocoded
    end

    it 'does not fetch coordinates when lat and lng are present' do
      allow(address).to receive(:geocoded?).and_return(true)
      expect(Geocoder).to receive(:coordinates).never
      address
    end
  end

  describe 'reverse geocoding' do
    subject(:address) { described_class.new(lat: lat, lng: lng) }

    let :payload do
      {
        'usa'=> {
          'uscity' => 'WASHINGTON',
          'usstnumber' => '1',
          'state' => 'PA',
          'zip' => '20500',
          'usstaddress' => 'Pennsylvania AVE'
        }
      }
    end

    let(:result) { [ double(data: payload) ] }

    it 'reverse geocodes with Geocoder API' do
      expect(Geocoder).to receive(:address).with([lat, lng]).and_return result
      address
    end

    it 'is reverse geocoded' do
      expect(address).to be_reverse_geocoded
    end

    it 'does not fetch address when address is present' do
      allow(address).to receive(:reverse_geocoded?).and_return(true)
      expect(Geocoder).to receive(:address).never
      address
    end
  end

  describe 'distance finding' do
    let(:detroit) { FactoryGirl.build :address, :as_detroit }
    let(:kansas_city) { FactoryGirl.build :address, :as_kansas_city }

    it 'calculates distance with the Geocoder API' do
      expect(Geocoder::Calculations).to receive(:distance_between).with detroit.coordinates, kansas_city.coordinates
      detroit.miles_to(kansas_city)
    end

    it 'returns the distance between two addresses' do
      expect(detroit.miles_to(kansas_city)).to be > 0
    end

    it 'does not attempt to retrieve distances multiple times for the same address' do
      detroit.distance = 500
      detroit.instance_variable_set(:@other_address, kansas_city)
      expect(Geocoder::Calculations).to receive(:distance_between).never
      detroit.miles_to(kansas_city)
    end
  end

  describe 'comparison' do
    let(:detroit) { FactoryGirl.build :address, :as_detroit, distance: 100 }
    let(:kansas_city) { FactoryGirl.build :address, :as_kansas_city, distance: 500 }
    let(:white_house) { FactoryGirl.build :address, distance: 400 }
    let(:las_vegas)  { FactoryGirl.build :address, distance: 700 }

    it 'sorts them in ascending order' do
      expect([detroit, kansas_city, white_house, las_vegas].sort).to eq [detroit, white_house, kansas_city, las_vegas]
    end
  end
end
