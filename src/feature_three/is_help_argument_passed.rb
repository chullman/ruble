def is_help_argument_passed?(*help_args)

    terminal_argument = ""

    terminal_argument = ARGV[0] if ARGV[0]

    if help_args.include?(terminal_argument)
        return true
    elsif terminal_argument != "" && !(help_args.include?(terminal_argument))
        puts "ERROR: Invalid terminal argument. Try: #{help_args.join(", ").to_s} (to display help)"
        puts "Continuing..."
        puts "\n"
    end

    return false
end