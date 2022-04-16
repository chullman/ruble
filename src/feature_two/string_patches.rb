# "Monkey patching" Ruby's String class the 'right' way, according to this doc:
# https://ruby-doc.org/core-2.4.0/doc/syntax/refinements_rdoc.html (viewed 16/04/2022)

require 'colorized_string'

module ColorizeStringPatches
    refine String do
        def color(text_color=:default, background_color=:default)
            return ColorizedString[self.to_s].colorize(:color => text_color, :background => background_color)
        end
    end
end