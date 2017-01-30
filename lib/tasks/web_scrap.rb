require 'net/http'
require 'rest-client'

def add_phonenumbers(url_array)
  while url_array.length > 0
    url = url_array.pop
    response = RestClient.get(url)
  end
end

def find_all_external_urls(url)
  response = RestClient.get(url)
  body = response.body
  url_locations = body.split('href="')[1..-2]
  urls = []

  url_locations.each do |location|
    new_url = location.split('"').first
    if new_url.include?('www.')
      urls << new_url
    else
      new_url = url + new_url
      urls << new_url
    end
  end

  return urls
end
