class CityWorker
  include Sidekiq::Worker

  def perform(*args)
    sputnik = SputnikApiService.new

    cities = sputnik.get :cities
    cities_count = cities.length
    puts "Total city count: #{cities_count}"
    cities.each_with_index do |city, index|
      puts "total: #{cities_count}, current: #{index}"
      params = sputnik.get :cities, id: city["id"]
      City.create(params)
    end
  end
end
