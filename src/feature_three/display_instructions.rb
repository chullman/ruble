using ColorizeStringPatches

require 'tty-table'

def display_instructions
    puts "\n"
    puts "HOW TO PLAY:"
    puts "You will have #{"6".color(:green)} attempts to guess a randomly selected, recognised #{"5-letter".color(:green)} English word, known as the Wordle, by inputting letters 'a' to 'z' to form a recognised 5-letter English word as your guess."
    puts "For every valid guess you make, you will get the following feedback on how close you are to guessing the Wordle:"
    puts "\n"
    puts "For example, let's assume the chosen Wordle for the game is the word: #{"HELLO".color(:green)} (of course, you won't know what the chosen Wordle is until the end of the game)"
    puts "You enter the word, \"HOLLY\" as your guess, so you'll receive the following feedback:"

    answers_storage = AnswersStorage.new(6)

    process_valid_answer("holly", "hello", answers_storage)

    puts "\n"
    display_results(answers_storage)
    puts "\n"
    puts "The letters, 'H' and both 'L's are both IN the chosen Wordle AND in the correct position in the Wordle, so they are marked #{" GREEN ".color(:black, :light_green)} #{"".color(:deafult, :default)}"
    puts "\n"
    puts "The letter, 'O' is IN the chosen Wordle BUT NOT in the correct position in the Wordle, so it is marked #{" ORANGE ".color(:black, :yellow)} #{"".color(:deafult, :default)}"
    puts "\n"
    puts "The letter, 'Y' is NOT in the chosen Wordle at all, so it is marked #{" GREY ".color(:light_white, :light_black)} #{"".color(:deafult, :default)}"
    puts "\n"

    return nil
end