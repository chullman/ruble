require_relative './feature_one/filehandler'
require_relative './feature_one/jsonhandler'
require_relative './feature_one/is_valid_input'
require_relative './feature_one/fetch_random_wordle'

require_relative './feature_two/string_patches'
using ColorizeStringPatches

require_relative './nilobjecterror'

file_handler = FileHandler.new

file = file_handler.try_file_open("./misc_feature/strip_source_dict_wordnet.json")

if file.nil?
    raise NilOjbectError.new("file")
end

output_string = file_handler.try_file_read(file)


json_handler = JSONHandler.new

json_results = json_handler.try_parse_json(output_string)

if json_results.nil?
    raise NilOjbectError.new("json_results")
end

def get_user_word
    print ": "
    return gets.chomp
end


word_input = get_user_word
until is_valid_input?(word_input, 5, json_results)
    puts "Sorry, that is not a valid 5 letter word, please try again:"
    word_input = get_user_word
end

puts word_input.strip.upcase + " is valid"

puts "this will be red".color(:red)