# LICENSE INFO FOR WORDNET - BELOW:
# Copied from the WordNet 2.1 for Windows software.
# Also referenced here: https://wordnet.princeton.edu/license-and-commercial-use (last viewed 14/04/2022)

    # WordNet Release 2.1

    # This software and database is being provided to you, the LICENSEE, by  
    # Princeton University under the following license.  By obtaining, using  
    # and/or copying this software and database, you agree that you have  
    # read, understood, and will comply with these terms and conditions.:  
    
    # Permission to use, copy, modify and distribute this software and  
    # database and its documentation for any purpose and without fee or  
    # royalty is hereby granted, provided that you agree to comply with  
    # the following copyright notice and statements, including the disclaimer,  
    # and that the same appear on ALL copies of the software, database and  
    # documentation, including modifications that you make for internal  
    # use or for distribution.  
    
    # WordNet 2.1 Copyright 2005 by Princeton University.  All rights reserved.  
    
    # THIS SOFTWARE AND DATABASE IS PROVIDED "AS IS" AND PRINCETON  
    # UNIVERSITY MAKES NO REPRESENTATIONS OR WARRANTIES, EXPRESS OR  
    # IMPLIED.  BY WAY OF EXAMPLE, BUT NOT LIMITATION, PRINCETON  
    # UNIVERSITY MAKES NO REPRESENTATIONS OR WARRANTIES OF MERCHANT-  
    # ABILITY OR FITNESS FOR ANY PARTICULAR PURPOSE OR THAT THE USE  
    # OF THE LICENSED SOFTWARE, DATABASE OR DOCUMENTATION WILL NOT  
    # INFRINGE ANY THIRD PARTY PATENTS, COPYRIGHTS, TRADEMARKS OR  
    # OTHER RIGHTS.  
    
    # The name of Princeton University or Princeton may not be used in  
    # advertising or publicity pertaining to distribution of the software  
    # and/or database.  Title to copyright in this software, database and  
    # any associated documentation shall at all times remain with  
    # Princeton University and LICENSEE agrees to preserve same.  


require 'net/http'
require 'json'

# https://ruby-doc.org/stdlib-2.2.3/libdoc/net/http/rdoc/Net/HTTP.html
uri = URI('https://raw.githubusercontent.com/chullman/ruble/e79e3d6ae63632ee63436fb47aa5b8651aff6c1a/src/misc_feature/all_words_from_wordnet_2_1.txt')

$response_2xx_success = false

def fetch_from_http(uri_str, limit = 10)
    
    raise ArgumentError, 'too many HTTP redirects' if limit == 0
  
    response = Net::HTTP.get_response(URI(uri_str))
  
    case response
    when Net::HTTPSuccess then
        $response_2xx_success = true
        response.body
    when Net::HTTPRedirection then
      location = response['location']
      warn "redirected to #{location}"
      fetch_from_http(location, limit - 1)
    else
      response.value
    end
end

def strip_to_custom_json(body)
    json_formatted = "["

    (body).split("\n").each do |line|
        words_in_a_line = line.split(" ")

        # explanation of this regex and the gsub method: https://stackoverflow.com/a/6344630
        special = "?<>',?[]}{=-)(*&^%$#`~{}_\""
        special_char_regex = /[#{special.gsub(/./){|char| "\\#{char}"}}]/

        words_in_a_line[0] = words_in_a_line[0].to_s

        if words_in_a_line[0].length == 5 && !(words_in_a_line[0].include?(" ")) && !(/\d/.match(words_in_a_line[0])) && !(words_in_a_line[0] =~ special_char_regex)
            json_formatted += "\"#{words_in_a_line[0]}\","
        end
    end

    # remove the very last comma char
    json_formatted.chop!

    json_formatted += "]"
    json_formatted = JSON.parse(json_formatted)
    json_formatted.uniq!
    json_formatted.sort!
    json_formatted
end

response_body = fetch_from_http(uri)
if $response_2xx_success == true
    File.open("strip_source_dict_wordnet.json", "w") { |f| f.write strip_to_custom_json(response_body) }
end

