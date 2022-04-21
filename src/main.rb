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
    puts "The Wordle was: #{wordle.to_s.upcase.color(:green)}"
end

def game_over_you_won(wordle, score, limit)
    puts "YOU WON!! :)".color(:green)
    puts "Your score is: #{score.to_s}/#{limit.to_s}".color(:green)
    puts "The Wordle was: #{wordle.to_s.upcase.color(:green)}"
end


def process_valid_answer(input, wordle, answers_storage)
    answer_processor = AnswerProcessor.new(input, wordle)

    # check_for_greens must be called before calling check_for_oranges for the AnswerProcessor logic to work
    answer_processor.check_for_greens
    answer_processor.check_for_oranges


    answers_storage.add(answer_processor.answer_results_hash)

end


def play(wordle, json_results, answers_storage)

    game_ending = false

    until game_ending

        input = get_user_answer(answers_storage.answers.length+1)

        if is_giving_up?(input)
            puts "Are you sure you want to give up? - Enter: (y)es / (n)o"
            input = get_user_confirmation
            if confirmed?(input)
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
                    game_over_you_won(wordle, answers_storage.answers.length, 6)                
                elsif answers_storage.answers.length == answers_storage.limit
                    game_ending = true
                    game_over_you_lost(wordle)
                end
            end
            
        end

    end

    return nil

end

def game(json_results)

    puts "- A Ruby Wordle game replica by Christopher Hullman"
    puts "If at any point you would like to give up? Enter 'give up' or 'quit' or 'exit' (without the quotes)."

    wordle = fetch_random_wordle(json_results)

    puts "The wordle is: #{wordle}"

    answers_storage = AnswersStorage.new(6)

    play(wordle, json_results, answers_storage)

    if !(answers_storage.answers.empty?)
        puts "Would you like to save your game result to a PDF file? - Enter: (y)es / (n)o"
        input = get_user_confirmation
        if confirmed?(input)
            try_generate_pdf(wordle, answers_storage, "my_ruble_results.pdf") 
        end
    end

    puts "THANK YOU FOR PLAYING RUBLE!"

    puts "Would you like to play again? - Enter: (y)es / (n)o"
    input = get_user_confirmation
    if confirmed?(input)
        game(json_results)
        return nil
    else
        puts "Exiting..."
    end

    return nil

end

game(json_results)





