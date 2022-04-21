def is_giving_up?(input)
    input = input.to_s.strip.downcase

    if input == "give up" || input == "quit" || input == "exit"
        return true
    end
    return false
end

def confirmed?(input)
    input = input.to_s.strip.downcase
    
    if input == "y" || input == "yes"
        return true
    end
    return false
end
