class AnswerProcessor

    attr_reader :answer_results_hash

    def initialize(input, wordle)
        @input_letters = input.to_s.strip.downcase.split('')
        @wordle_letters = wordle.to_s.strip.downcase.split('')
        @answer_results_hash = generate_initial_hash
    end

    def check_for_greens
        @answer_results_hash.each do |key, value|
            if @wordle_letters[key-1] == value[0]
                @answer_results_hash[key] = [value[0], :green]
            end
        end
    end

    def check_for_oranges
        @answer_results_hash.each do |key, value|
            if value[1] != :green
                @wordle_letters.each_with_index do |wordle_letter, wordle_index|
                    if (value[0] == wordle_letter) && (key-1 != wordle_index)
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