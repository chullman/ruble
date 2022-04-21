require 'json'

class JSONHandler
    def initialize
    end

    def try_parse_json(json_string)
        begin
            json_results = JSON.parse(json_string)
        rescue JSON::ParserError => e
            puts "\n"
            puts "ERROR: The string argument passed into try_parse_json method was unable to be parsed as valid JSON"
            puts "ERROR @: #{e.backtrace[2]}"
            puts "\n"
            return nil
        else
            if json_results.empty?
                puts "\n"
                puts "ERROR: The JSON syntax is valid, but it is empty of content"
                puts "\n"
                return nil
            else
                return json_results
            end
        end
    end

end