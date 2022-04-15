require_relative './feature_one/filehandler'
require_relative './feature_one/jsonhandler'

file_handler = FileHandler.new

file = file_handler.try_file_open("./misc_feature/strip_source_dict_wordnet.json")

output_string = file_handler.try_file_read(file) unless file.nil?


json_handler = JSONHandler.new

json_results = json_handler.try_parse_json(output_string)

puts json_results unless json_results.nil?