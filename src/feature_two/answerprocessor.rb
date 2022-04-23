# A critical class for this app, as this handles checking and flagging the GREENS, ORANGES, and GREYS, in the user's word guess

class AnswerProcessor

    attr_reader :answer_results_hash

    def initialize(input, wordle)
        @input_letters = input.to_s.strip.downcase.split('')
        @wordle_letters = wordle.to_s.strip.downcase.split('')
        # Generate the initial hash, and by default, flag every letter as GREY
        # this will return something like: {1 => ['h', :grey], 2 => ['e', :grey], 3 => ['l', :grey], 4 => ['l', :grey], 5 => ['o', :grey]}
        @answer_results_hash = generate_initial_hash
    end

    # Check for any GREENS in the word
    # Must be done before calling 'check_for_oranges' method below
    def check_for_greens
        @answer_results_hash.each do |key, value|
            # If a letter of the user's word guess is equal to the letter in the Wordle and in the same position as the Wordle
            # Flag it GREEN
            if @wordle_letters[key-1] == value[0]
                @answer_results_hash[key] = [value[0], :green]
            end
        end
    end

    def check_for_oranges

        # Any green letters found in the answer word, remove those letters from the wordle so it won't be incorrectly flagged as orange in the user's word guess
        # The string "REMOVED" is just a placeholder, but can really be any non-1-character string, as we can be assured that this will never get matched against a letter in the user's word guess as being equal
        @answer_results_hash.each do |key, value|
            if value[1] == :green
                @wordle_letters.delete_at(key-1)
                @wordle_letters.insert(key-1, "REMOVED")
            end
        end

        # Now we can begin checking for ORANGES
        @answer_results_hash.each do |key, value|
            # Skip checking a letter in the user's guess if it has already been flagged as GREEN, as we don't want to override that with ORANGE
            if value[1] != :green
                @wordle_letters.each_with_index do |wordle_letter, wordle_index|
                    # If the letter in the user's guess is contained in the Wordle, anywhere at all, flag it as ORANGE
                    if (value[0] == wordle_letter)
                        @answer_results_hash[key] = [value[0], :orange]
                    end
                end
            end
        end
    end

    private

    def generate_initial_hash
        answer_results_hash = {}

        @input_letters.each_with_index do |letter, index|
            answer_results_hash[index+1] = [letter, :grey]
        end

        return answer_results_hash
    end

    
end