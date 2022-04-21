using ColorizeStringPatches

def display_results(answers_storage)

    answers_storage.answers.each do |answer_hash|
        for n in 1..5
            if answer_hash[n][1] == :green
                print "#{answer_hash[n][0].to_s.upcase.color(:light_white, :light_green)} "
            elsif answer_hash[n][1] == :orange
                print "#{answer_hash[n][0].to_s.upcase.color(:light_white, :yellow)} "
            elsif answer_hash[n][1] == :grey
                print "#{answer_hash[n][0].to_s.upcase.color(:light_white, :light_black)} "
            end
        end
        puts "\n\n"
    end

end