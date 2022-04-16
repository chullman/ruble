require_relative './feature_one/filehandler'
require_relative './feature_one/jsonhandler'

file_handler = FileHandler.new

file = file_handler.try_file_open("./misc_feature/strip_source_dict_wordnet.json")

output_string = file_handler.try_file_read(file) unless file.nil?


json_handler = JSONHandler.new

json_results = json_handler.try_parse_json(output_string)

# puts json_results unless json_results.nil?

def is_valid_input?(input, input_length_restriction, all_dict_words)

    input = input.to_s.strip.downcase

    if input.length != input_length_restriction
        return false
    end

    # explanation of this regex and the gsub method: https://stackoverflow.com/a/6344630
    special = "?<>',?[]}{=-)(*&^%$#`~{}_\""
    special_char_regex = /[#{special.gsub(/./){|char| "\\#{char}"}}]/

    if input.include?(" ") || /\d/.match(input) || input =~ special_char_regex
        return false
    end

    if !(all_dict_words.include?(input))
        puts "entered"
        return false
    end

    return true
end

print ": "
input = gets.chomp

if is_valid_input?(input, 5, json_results)
    
end