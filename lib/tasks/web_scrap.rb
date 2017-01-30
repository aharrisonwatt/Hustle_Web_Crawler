require 'net/http'
require 'rest-client'
require 'byebug'

def add_phonenumbers(url_array)
  #use set so we don't go through same page twice
  seen_urls = Set.new

  #use a que to check all URLS
  while url_array.length > 0
    url = url_array.shift
    #add new url to seen urls set
    seen_urls.add(url)
    response = RestClient.get(url){|response, request, result| response }
    next unless response.body

    #Add new links to que
    urls = find_all_external_urls(response, seen_urls, url)
    url_array.concat(urls)

    #find and save all phone numbers on page to DB
    phone_reg = /(\d{3}[-.()]\d{3}[-.]\d{4})/
    match_data = phone_reg.match(response.body)

    match_data.to_a.each do |number|
      Phonenumber.create({
        url: url,
        number: number
      })
    end
  end
end

def find_all_external_urls(response, seen_urls, url)
  urls = []
  body = response.body
  return urls unless body.include?('href="')
  url_locations = body.split('href="')[1..-1]

  url_locations.each do |location|
    new_url = location.split('"').first
    new_url = url + new_url if new_url.include?('www.') == false
    urls << new_url unless seen_urls.include?(new_url)
  end

  return urls
end

add_phonenumbers(['http://www.yellowpages.com/san-francisco-ca/movie-theatres'])
