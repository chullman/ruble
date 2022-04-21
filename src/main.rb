require_relative './feature_one/filehandler'
require_relative './feature_one/jsonhandler'
require_relative './feature_one/is_valid_input'
require_relative './feature_one/fetch_random_wordle'

require_relative './feature_two/string_patches'
require_relative './feature_two/answerprocessor'
require_relative './feature_two/answersstorage'
require_relative './feature_two/is_giving_up'
require_relative './feature_two/is_game_won'

using ColorizeStringPatches

require_relative './feature_three/display_results'
require_relative './feature_three/try_generate_pdf'


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

wordle = fetch_random_wordle(json_results)


puts "The wordle is: #{wordle}"

answers_storage = AnswersStorage.new(6)

def get_user_answer(attempt_no)
    print "Attempt ##{attempt_no}: "
    return gets.chomp
end

def get_user_confirmation
    print "(y)es or (n)o ? : "
    return gets.chomp
end

def game_over_you_lost(wordle)
    puts "GAME OVER YOU LOST"
    puts "The Wordle was #{wordle.upcase}"
end

def game_over_you_won(wordle)
    puts "YOU WON!! :)"
    puts "The Wordle was #{wordle.upcase}"
end


def process_valid_answer(input, wordle, answers_storage)
    answer_processor = AnswerProcessor.new(input, wordle)

    answer_processor.check_for_greens
    answer_processor.check_for_oranges

    # puts answer_processor.answer_results_hash

    answers_storage.add(answer_processor.answer_results_hash)

    # answers_storage.answers.each do |answer|
    #     puts "#{answer}"
    # end

    # attempt_counter += 1

    # input = get_user_answer(attempt_counter)
end


def play(wordle, json_results, answers_storage)

    game_ending = false

    until game_ending

        input = get_user_answer(answers_storage.answers.length+1)

        if is_giving_up?(input)
            puts "Are you sure you want to give up? - Enter: (y)es / (n)o"
            input = get_user_confirmation
            if confirm_giving_up?(input)
                game_ending = true
                game_over_you_lost(wordle)
                display_results(answers_storage)
            end
        else
            if !(is_valid_input?(input, 5, json_results))
                puts "Sorry, that is not a valid 5 letter word, please try again:"
            else
                process_valid_answer(input, wordle, answers_storage)

                display_results(answers_storage)

                if is_game_won?(answers_storage.answers[-1])
                    game_ending = true
                    game_over_you_won(wordle)                
                elsif answers_storage.answers.length == answers_storage.limit
                    game_ending = true
                    game_over_you_lost(wordle)
                end
            end
            
        end

    end

    return nil

end

play(wordle, json_results, answers_storage)

if !(answers_storage.answers.empty?)
    try_generate_pdf(wordle, answers_storage, "my_ruble_results.pdf") 
end







