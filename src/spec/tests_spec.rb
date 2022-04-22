require_relative '../feature_one/filehandler'
require_relative '../feature_two/answerprocessor'

describe FileHandler do
    it 'it should be able to successfully OPEN the file containing all valid 5-letter words' do
        file_handler = FileHandler.new
        file = file_handler.try_file_open("./misc_feature/strip_source_dict_wordnet.json")

        expect(file).to be_truthy
    end

    it 'it should be able to successfully READ the file containing all valid 5-letter words and not be empty' do
        file_handler = FileHandler.new
        file = file_handler.try_file_open("./misc_feature/strip_source_dict_wordnet.json")
        output_string = file_handler.try_file_read(file)

        expect(output_string).not_to be_empty
    end
end

describe AnswerProcessor do
    it 'should be able to flag \'GREEN\' letters correctly if the wordle is \'hello\' and the user\'s guess is \'holly\'' do
        answer_processor = AnswerProcessor.new("holly", "hello")
        answer_processor.check_for_greens

        expect(answer_processor.answer_results_hash).to eq ({1 => ["h", :green], 2=> ["o", :grey], 3 => ["l", :green], 4 => ["l", :green], 5 => ["y", :grey]})
    end

    it 'should be able to flag \'ORANGE\' letters correctly if the wordle is \'hello\' and the user\'s guess is \'holly\'' do
        answer_processor = AnswerProcessor.new("holly", "hello")
        answer_processor.check_for_greens
        answer_processor.check_for_oranges

        expect(answer_processor.answer_results_hash).to eq ({1 => ["h", :green], 2=> ["o", :orange], 3 => ["l", :green], 4 => ["l", :green], 5 => ["y", :grey]})
    end
end