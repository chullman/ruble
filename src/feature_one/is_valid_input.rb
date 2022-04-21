def is_valid_input?(input, input_length_restriction, all_dict_words)

    input = input.to_s.strip.downcase

    if input.length != input_length_restriction
        return false
    end

    valid_alphabet_chars = ('a'..'z').to_a

    input.each_char do |input_char|
        if !(valid_alphabet_chars.include?(input_char))
            return false
        end
    end


    if !(all_dict_words.include?(input))
        return false
    end

    return true
end