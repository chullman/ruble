using ColorizeStringPatches

require 'tty-table'

def display_results(answers_storage)

    answers_storage.answers.each do |answer_hash|
        table = TTY::Table.new
        colorized_answer = []
        for n in 1..5
            if answer_hash[n][1] == :green
                colorized_answer << "  ".color(:default, :light_green) + answer_hash[n][0].to_s.upcase.color(:black, :light_green) + "  ".color(:default, :light_green)
            elsif answer_hash[n][1] == :orange
                colorized_answer << "  ".color(:default, :yellow) + answer_hash[n][0].to_s.upcase.color(:black, :yellow) + "  ".color(:default, :yellow)
            elsif answer_hash[n][1] == :grey
                colorized_answer << "  ".color(:default, :light_black) + answer_hash[n][0].to_s.upcase.color(:light_white, :light_black) + "  ".color(:default, :light_black)
            end
        end
        table << colorized_answer

        begin
            puts table.render(:unicode, padding: [1,1,1,1])
        rescue
            puts "ERROR: Terminal window width is too small to correctly display the results. Please enlarge your window."
            puts table.render(:unicode)
        end

    end

    return nil
end