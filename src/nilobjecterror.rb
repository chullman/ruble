class NilOjbectError < StandardError
    def initialize(message)
        super("\nERROR:\"#{message}\" is a nil object\n")
    end
end



