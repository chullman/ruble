require 'net/http'
require 'json'

# https://www.twilio.com/blog/2015/10/4-ways-to-parse-a-json-api-with-ruby.html
# https://ruby-doc.org/stdlib-2.2.3/libdoc/net/http/rdoc/Net/HTTP.html
uri = URI('https://raw.githubusercontent.com/matthewreagan/WebstersEnglishDictionary/master/dictionary_alpha_arrays.json')

def fetch(uri_str, limit = 10)
    
    raise ArgumentError, 'too many HTTP redirects' if limit == 0
  
    response = Net::HTTP.get_response(URI(uri_str))
  
    case response
    when Net::HTTPSuccess then
      
      all_five_letter_words = []

      full_array = JSON.parse(response.body)

      full_array.each do |hash|
        hash.each do |key, value|
            if key.length == 5
                all_five_letter_words.push(key.to_s)
            end
        end
      end

      all_five_letter_words.sort!
      
    when Net::HTTPRedirection then
      location = response['location']
      warn "redirected to #{location}"
      fetch(location, limit - 1)
    else
      response.value
    end
end

puts fetch(uri)