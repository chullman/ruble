class NilOjbectError < StandardError
    def initialize(message)
        super("ERROR:\"#{message}\" is a nil object")
    end
end



