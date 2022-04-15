class FileHandler

    def initialize
      @file_path = ""
    end
  
    def try_file_open(file_path)
      @file_path = file_path
      begin
        file = File.open(@file_path)
  
        return file
  
      rescue Errno::ENOENT => e
  
        puts "ERROR: No such file \"#{@file_path}\" found"
        puts "ERROR @: #{e.backtrace[1]}"
        try_close_file(file)
  
      rescue Errno::EACCES => e
  
        puts "ERROR: Permission denied in opening the file #{@file_path}"
        puts "Ensure that everyone has read access to the file by running - chmod 444 #{@file_path}"
        puts "ERROR @: #{e.backtrace[1]}"
        try_close_file(file)       
       
      end
    end
  
    def try_file_read(file)
  
      file_contents = file.read
  
      try_close_file(file)
  
      file_contents.chomp!
  
      if file_contents.empty?
        raise ArgumentError, "ERROR: The file \"#{@file_path}\" is empty"
      end
  
      return file_contents
  
    end
  
    private 
    
    def try_close_file(file)
      file.close unless file.nil?
    end
  
end

require 'json'

class JSONHandler
    def initialize
    end

    def try_parse_json(json_string)
        begin
            json_results = JSON.parse(json_string)
        rescue JSON::ParserError => e
            puts "ERROR: The string argument passed into try_parse_json method was unable to be parsed as valid JSON"
            puts "ERROR @: #{e.backtrace[2]}"
            return nil
        else
            if json_results.empty?
                puts "ERROR: The JSON syntax is valid, but it is empty of content"
                return nil
            else
                return json_results
            end
        end
    end

end

  
file_handler = FileHandler.new

file = file_handler.try_file_open("../misc_feature/strip_source_dict_wordnet.json")

output_string = file_handler.try_file_read(file) unless file.nil?


json_handler = JSONHandler.new

json_results = json_handler.try_parse_json(output_string)

puts json_results unless json_results.nil?