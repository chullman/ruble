# The main container that will hold all (up to 6) word results generated from './feature_two/answerprocessor.rb'

class AnswersStorage

    attr_reader :answers, :limit

    def initialize(limit = 6)
        @answers = []
        @limit = limit
    end

    def add(answer_hash)
        if @answers.length < @limit
            @answers.push(answer_hash)
        else
            puts "ERROR: AnswersStorage object already holds the maximum number of user's answer attempts of #{@limit.to_s}"
            puts "To change this limit, pass in a new integer value in AnswersStorage.new(value)"
        end
    end

end