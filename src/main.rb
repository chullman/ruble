# THE MAIN ENTRY FILE FOR THIS APP - 'RUBLE'

# Call in every single feature file, except for the Misc feature (as that doesn't need to be executed by this app)

require_relative './feature_one/filehandler'
require_relative './feature_one/jsonhandler'
require_relative './feature_one/is_valid_input'
require_relative './feature_one/fetch_random_wordle'

require_relative './feature_two/string_patches'
require_relative './feature_two/answerprocessor'
require_relative './feature_two/answersstorage'
require_relative './feature_two/is_giving_up'
require_relative './feature_two/is_game_won'

# Call in our custom created module that refines/extends the String class with our Colorize gem wrapper (see './feature_two/string_patches.rb')
using ColorizeStringPatches

require_relative './feature_three/display_results'
require_relative './feature_three/try_generate_pdf'
require_relative './feature_three/display_instructions'
require_relative './feature_three/is_help_argument_passed'


require_relative './nilobjecterror'

require 'tty-prompt'
require 'artii'

file_handler = FileHandler.new

# Attempt to open our JSON file (created in the Misc feature) which contains ALL valid/recognised 5-letter words that our app will refer to, and return a non-nil file object if successful
file = file_handler.try_file_open("./misc_feature/strip_source_dict_wordnet.json")

if file.nil?
    # My custom Exception class, inherited from StandardError (see './nilobjecterror.rb')
    raise NilOjbectError.new("file")
end

# Try to read the contents of the JSON file, and if successful, return a non-empty string (in JSON-parsable format)
# Probably not the most performance efficient, as the entire contents of the file will be stored in memory throughout the entire lifecycle of this app
output_string = file_handler.try_file_read(file)


json_handler = JSONHandler.new

# Try to parse the entire string, which in our case will return an array
# Again, probably not the most performance efficient to have an array of 5000+ elements, but it works as far as I can tell
json_results = json_handler.try_parse_json(output_string)

if json_results.nil?
    raise NilOjbectError.new("json_results")
end

# Will be called each time to collect the user's word guess
def get_user_answer(attempt_no)
    print "Attempt ##{attempt_no}: "
    return gets.chomp
end

# Will be called to get user's confirmation
# TO DO: Change this to a menu selection with Tty-prompt gem
def get_user_confirmation
    print "(y)es or (n)o ? : "
    return gets.chomp
end

# Output display when the user loses the game
def game_over_you_lost(wordle)
    puts "\n"
    puts "Sorry, Game Over."
    puts "\n"
    puts "The Wordle was: #{wordle.to_s.upcase.color(:green)}"
end

# Output display when the user wins the game
def game_over_you_won(wordle, score, limit)
    puts "\n"
    puts "Congratulations! YOU WON! :)".color(:green)
    puts "\n"
    # Score displayed as x/6 attempts (6 being the max limit of allowed guesses)
    puts "Your score is: #{score.to_s}/#{limit.to_s} attempts".color(:green)
    puts "\n"
    puts "The Wordle was: #{wordle.to_s.upcase.color(:green)}"
end

# This will be called for every user's word guess AFTER first determining that the user has entered a valid 5-letter word (see './feature_one/is_valid_input.rb')

def process_valid_answer(input, wordle, answers_storage)
    # Upon initialization of AnswerProcessor, a hash will be generated of every letter in 'input', and each letter flagged as the colour GREY by default
    # So hash will look like the following (e.g. the input word is 'hello')
    # {1 => ['h', :grey], 2 => ['e', :grey], 3 => ['l', :grey], 4 => ['l', :grey], 5 => ['o', :grey]}
    # Note that I'm storing the index position of each letter as the Keys. This is because in OLD Ruby versions, there's apparently no persistant order of key/value elements in a hash (unlike with arrays).+
    answer_processor = AnswerProcessor.new(input, wordle)

    # 'check_for_greens' method MUST BE called before calling 'check_for_oranges' method for the AnswerProcessor logic to work, else my letter checking logic will break
    # See code in './feature_two/answerprocessor.rb' for details
    answer_processor.check_for_greens
    answer_processor.check_for_oranges

    # Store the results of every user's valid guess attempt in an array of 1-6 guess attempts
    # This is important as we'll be contanstly referring to this storage to keep track of the number of user's guesses attempts,
    # and to display all previous guesses to the user after every valid guess, and to generate their final results PDF
    # and will be checked to see if the user has won
    answers_storage.add(answer_processor.answer_results_hash)

end

# The main loop to collect up to all 6 user guess attempts, and handle logic if the user's guess is invalid or that they would like to give up.
def play(wordle, json_results, answers_storage)

    game_ending = false

    puts "Please enter your 5-letter word guess:".color(:green)
    puts "\n"

    until game_ending

        input = get_user_answer(answers_storage.answers.length+1)

        if is_giving_up?(input)
            # The user wants to give up - that is, they entered either 'give up', 'quit', or 'exit' in the input prompt
            # then ask if they're sure they want to give up
            puts "Are you sure you want to give up? - Enter: (y)es / (n)o".color(:light_red)
            input = get_user_confirmation
            if confirmed?(input)
                game_ending = true
                # Display game over
                game_over_you_lost(wordle)
            end
        else
            if !(is_valid_input?(input, 5, json_results))
                puts "Sorry, that is not a recognised 5-letter word, please try again:"
            else
                # This block is only executed if the user enters a valid/recognised 5-letter word

                # Process the guess - that is, check for any GREENS and any ORANGES
                process_valid_answer(input, wordle, answers_storage)

                display_results(answers_storage)

                # After every valid guess (which will be the last element pushed into our answers_storage array), check if they've won
                if is_game_won?(answers_storage.answers[-1])
                    game_ending = true
                    # Display 'you've won'
                    game_over_you_won(wordle, answers_storage.answers.length, 6)
                # Otherwise, after every valid guess, check if they've reached the limit of 6 max guess attempts               
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

# The main method for running the entire game!
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

    title_menu_selection = title_prompt.select("What would you like to do?", title_menu_choices, symbols: { marker: ">" })

    case title_menu_selection

    # Case the user wants to play the game...
    when 1
        puts "\n"
        puts "(If at any point you would like to give up? Enter 'give up' or 'quit' or 'exit', without the quotes.)".color(:black, :light_yellow)
        puts "\n"
        
        # From our array of ALL valid 5-letter words, grab one at random to use as the Wordle for the game
        wordle = fetch_random_wordle(json_results)

        # If you want to change the max number of allowed user guess attempts from 6, simply pass in a new integer value > 0
        answers_storage = AnswersStorage.new(6)

        # Run the main game loop
        play(wordle, json_results, answers_storage)

        # No point asking the user to save their results to a PDF if they didn't enter any valid guesses at all
        if !(answers_storage.answers.empty?)
            puts "Would you like to save your game result to a PDF file? - Enter: (y)es / (n)o"
            input = get_user_confirmation
            if confirmed?(input)
                # Attempt to generate the PDF
                # This could fail if there's no write access in the users 'src/' file directory, but there is code to handle this Exception (see './feature_three/try_generate_pdf.rb')
                try_generate_pdf(wordle, answers_storage, "my_ruble_results.pdf") 
            end
        end

        puts "Thank you for playing Ruble!"
        puts "\n"

        puts "Would you like to play again? - Enter: (y)es / (n)o"
        input = get_user_confirmation
        if confirmed?(input)
            game(json_results)
            # I always return from the method immediately after using any RECURSION to prevent any further unexpected code execution out of good practice
            return nil
        else
            puts "Exiting..."
        end
    
    # Case the user wants to see 'How To Play'
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

# Any number of arguments can be passed into the below 'is_help_argument_passed?' method (thanks to use of the splat operator)
# In this case, this will be called if the terminal argument ARGV[0] is "help", "--help" or "-h"
if is_help_argument_passed?("help", "--help", "-h")
    display_instructions
else
    # THE MOST IMPORTANT LINE IN THIS APP - runs the whole game! 
    game(json_results)
end





