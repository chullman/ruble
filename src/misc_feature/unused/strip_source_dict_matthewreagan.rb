# ****************************************************************
# PLEASE IGNORE THIS FILE
# ****************************************************************
# I wrote this code as a possible alternative for reading and extracting words from an external source dictionary
# It is not used

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

            # explanation of this regex and the gsub method: https://stackoverflow.com/a/6344630
            special = "?<>',?[]}{=-)(*&^%$#`~{}_\""
            special_char_regex = /[#{special.gsub(/./){|char| "\\#{char}"}}]/

            key = key.to_s

            if key.length == 5 && !(key.include?(" ")) && !(/\d/.match(key)) && !(key =~ special_char_regex)
                all_five_letter_words.push(key)
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

print fetch(uri)