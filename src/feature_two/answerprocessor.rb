class AnswerProcessor
    def initialize(input, wordle)
        @input_letters = input.to_s.strip.downcase.split('')
        @wordle_letters = wordle.to_s.strip.downcase.split('')
        @input_hash = generate_initial_hash
    end

    def check_for_greens
        @input_hash.each do |key, value|
            if @wordle_letters[key-1] == value[0]
                @input_hash[key] = [value[0], :green]
            end
        end

        return @input_hash
    end

    private

    def generate_initial_hash
        input_hash = {}

        @input_letters.each_with_index do |letter, index|
            input_hash[index+1] = [letter, :grey]
        end

        return input_hash
    end

    
end