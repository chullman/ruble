def is_help_argument_passed?(*help_args)

    terminal_argument = ""

    terminal_argument = ARGV[0] if ARGV[0]

    if help_args.include?(terminal_argument)
        return true
    elsif terminal_argument != "" && !(help_args.include?(terminal_argument))
        puts "ERROR: Invalid terminal argument. (to display help) Try running: ruby main.rb #{help_args.join(" 'OR' ").to_s}"
        puts "Continuing with app..."
        puts "\n"
    end

    return false
end