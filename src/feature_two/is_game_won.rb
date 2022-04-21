def is_game_won?(answer_hash)
    answer_hash.each do |key, value|
        if value[1] != :green
            return false
        end
    end
    return true
end