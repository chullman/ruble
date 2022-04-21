require 'prawn'

def try_generate_pdf(wordle, answers_storage)

    Prawn::Document.generate("hello.pdf") do
        text "Hello World!"
      end

end