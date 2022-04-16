# https://rapidapi.com/dpventures/api/wordsapi/

require 'uri'
require 'net/http'
require 'openssl'
require 'json'


def fetch(uri_str, limit = 10)
    
    raise ArgumentError, 'too many HTTP redirects' if limit == 0
  
    http = Net::HTTP.new(uri_str.host, uri_str.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    request = Net::HTTP::Get.new(uri_str)
    request["X-RapidAPI-Host"] = 'wordsapiv1.p.rapidapi.com'
    request["X-RapidAPI-Key"] = '(**TO ADD**)'

    response = http.request(request)
  
    case response
    when Net::HTTPSuccess then

        full_hash = JSON.parse(response.body)
        (full_hash["results"])["data"]
      
      
    when Net::HTTPRedirection then
      location = response['location']
      warn "redirected to #{location}"
      fetch(location, limit - 1)
    else
      response.value
    end
end


def fetch_page_results(page_counter)
    api_page_uri = URI("https://wordsapiv1.p.rapidapi.com/words/?letters=5&page=#{page_counter}")
    api_page_results = fetch(api_page_uri)
    api_page_results
end

all_five_letter_words = []

page_counter = 1
while !(fetch_page_results(page_counter).empty?) do
    puts "Processing page #{page_counter}..."
    fetch_page_results(page_counter).each do |word|

        # explanation of this regex and the gsub method: https://stackoverflow.com/a/6344630
        special = "?<>',?[]}{=-)(*&^%$#`~{}_"
        special_char_regex = /[#{special.gsub(/./){|char| "\\#{char}"}}]/

        if !(/\d/.match(word)) && !(word =~ special_char_regex) && !(word.include?(" "))
            all_five_letter_words.push(word)
        end
    end
    page_counter += 1
end

print all_five_letter_words