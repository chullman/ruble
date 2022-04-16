def is_valid_input?(input, input_length_restriction, all_dict_words)

    input = input.to_s.strip.downcase

    if input.length != input_length_restriction
        return false
    end

    # explanation of this regex and the gsub method: https://stackoverflow.com/a/6344630
    special = "?<>',?[]}{=-)(*&^%$#`~{}_\""
    special_char_regex = /[#{special.gsub(/./){|char| "\\#{char}"}}]/

    if input.include?(" ") || /\d/.match(input) || input =~ special_char_regex
        return false
    end

    if !(all_dict_words.include?(input))
        return false
    end

    return true
end