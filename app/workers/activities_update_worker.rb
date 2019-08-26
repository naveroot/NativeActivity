class ActivitiesUpdateWorker
  include Sidekiq::Worker

  def perform(*args)
    @sputnik = SputnikApiService.new
    @redis = Redis.new host: 'localhost', port: 6379, db: 15
    @page_number ||= 1
    @cities = City.all
    @cities.each do |city|
      add_activity_ids_to_redis city_id: city.id
    end
  end

  def add_activity_ids_to_redis(city_id:)
    puts "Searching activities for: #{City.find(city_id).name}..."
    page = 1
    loop do
      activities = @sputnik.get :products, city_id: city_id, page: page
      break  if activities.empty?

      activities.each do |activity|
        @redis.sadd"city_#{city_id}_activities_ids", activity['id']
        if Activity.exists? activity['id']
          puts "Activity already exist. Город: #{Activity.find(activity['id']).city.name}"
        else
          Activity.create id: activity['id'],
                          city_id: city_id,
                          title: activity['title'],
                          description: activity['description'],
                          photo: activity['image_big'],
                          price: activity['price']
        end
      end
      page += 1
    end
  end
end
