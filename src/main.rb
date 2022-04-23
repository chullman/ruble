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
require_relative './feature_three/display_instructions'
require_relative './feature_three/is_help_argument_passed'


require_relative './nilobjecterror'

require 'tty-prompt'
require 'artii'

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
    puts "\n"
    puts "Sorry, Game Over."
    puts "\n"
    puts "The Wordle was: #{wordle.to_s.upcase.color(:green)}"
end

def game_over_you_won(wordle, score, limit)
    puts "\n"
    puts "Congratulations! YOU WON! :)".color(:green)
    puts "\n"
    puts "Your score is: #{score.to_s}/#{limit.to_s} attempts".color(:green)
    puts "\n"
    puts "The Wordle was: #{wordle.to_s.upcase.color(:green)}"
end


def process_valid_answer(input, wordle, answers_storage)
    answer_processor = AnswerProcessor.new(input, wordle)

    # check_for_greens method must be called before calling check_for_oranges method for the AnswerProcessor logic to work
    answer_processor.check_for_greens
    answer_processor.check_for_oranges


    answers_storage.add(answer_processor.answer_results_hash)

end


def play(wordle, json_results, answers_storage)

    game_ending = false

    puts "Please enter your 5-letter word guess:".color(:green)
    puts "\n"

    until game_ending

        input = get_user_answer(answers_storage.answers.length+1)

        if is_giving_up?(input)
            puts "Are you sure you want to give up? - Enter: (y)es / (n)o".color(:light_red)
            input = get_user_confirmation
            if confirmed?(input)
                game_ending = true
                game_over_you_lost(wordle)
            end
        else
            if !(is_valid_input?(input, 5, json_results))
                puts "Sorry, that is not a recognised 5-letter word, please try again:"
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

        puts "\n"

    end

    return nil

end

def game(json_results)

    title = Artii::Base.new
    title = title.asciify("R u b l e")

    puts title
    puts "Welcome to Ruble!".color(:green)
    puts "\n"
    puts "- A Ruby-based, Wordle game replica by Christopher Hullman".color(:green)
    puts "\n"
    

    title_prompt = TTY::Prompt.new

    title_menu_choices = [
        {name: "Play Game", value: 1},
        {name: "Read 'How to Play'", value: 2}
    ]

    title_menu_selection = title_prompt.select("What would you like to do?", title_menu_choices)

    case title_menu_selection

    when 1
        puts "\n"
        puts "(If at any point you would like to give up? Enter 'give up' or 'quit' or 'exit', without the quotes.)".color(:black, :light_yellow)
        puts "\n"

        wordle = fetch_random_wordle(json_results)

        answers_storage = AnswersStorage.new(6)

        play(wordle, json_results, answers_storage)

        if !(answers_storage.answers.empty?)
            puts "Would you like to save your game result to a PDF file? - Enter: (y)es / (n)o"
            input = get_user_confirmation
            if confirmed?(input)
                try_generate_pdf(wordle, answers_storage, "my_ruble_results.pdf") 
            end
        end

        puts "Thank you for playing Ruble!"
        puts "\n"

        puts "Would you like to play again? - Enter: (y)es / (n)o"
        input = get_user_confirmation
        if confirmed?(input)
            game(json_results)
            # I always return from the method immediately after using recursion to prevent any further unexpected code execution
            return nil
        else
            puts "Exiting..."
        end
    
    when 2
        display_instructions
        puts "\n"
        print "Press any key to continue..."
        gets.chomp
        puts "\n"
        game(json_results)
        return nil
    end

    return nil

end

if is_help_argument_passed?("help", "--help", "-h")
    display_instructions
else
    game(json_results)
end





