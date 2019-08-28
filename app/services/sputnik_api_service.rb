# frozen_string_literal: true

require 'open-uri'
require 'json'
require 'csv'

class SputnikApiService
  attr_reader :cities

  def initialize; end

  def get(resource, *args)
    send(resource, *args)
  end

  def cities(*args)
    if args.empty?
      JSON.parse(api_request('cities', *args))
    else
      city = JSON.parse(api_request('cities', *args))
      { id: city['id'],
        name: city['name'],
        photo: city['geo']['description']['image'] }
    end
  end

  def products(*args)
    if args.empty? || args.first[:id].nil?
      JSON.parse(api_request('products', *args))
    else
      JSON.parse(api_request('products', *args))
    end
  end

  def api_request(resource, *args)
    url = URI.parse("https://api.sputnik8.com/v1/#{resource}" + params_generator(*args))
    Net::HTTP.get(url)
  end

  def params_generator(*args)
    return '?' + params_auth if args.empty?

    params = args.first
    row = []
    if params[:id].nil?
      row << '?'
    else
      row << '/' + params[:id].to_s + '?'
      params.delete(:id)
    end
    params.each do |key, value|
      row << "#{key}=#{value}&"
    end
    row.join('') + params_auth
  end

  def params_auth
    'api_key=' + ENV['SPUTNIK_API_KEY'] + '&username=' + ENV['SPUTNIK_USERNAME']
  end
end
