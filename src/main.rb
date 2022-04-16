require_relative './feature_one/filehandler'
require_relative './feature_one/jsonhandler'
require_relative './feature_one/is_valid_input'
require_relative './nilobjecterror'

file_handler = FileHandler.new

file = file_handler.try_file_open("./misc_feature/strip_source_dict_wordnet.json")

output_string = file_handler.try_file_read(file) unless file.nil?


json_handler = JSONHandler.new

json_results = json_handler.try_parse_json(output_string)

# puts json_results unless json_results.nil?


def get_user_word
    print ": "
    return gets.chomp
end

if json_results.nil?
    raise NilOjbectError.new("json_results")
end

word_input = get_user_word
until is_valid_input?(word_input, 5, json_results)
    puts "Sorry, that is not a valid 5 letter word, please try again:"
    word_input = get_user_word
end

puts word_input + " IS VALID"