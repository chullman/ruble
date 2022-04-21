require 'prawn'

def try_generate_pdf(wordle, answers_storage, file_path)

    begin
        Prawn::Document.generate(file_path) do
            text "Hello World!"
        end
    rescue Errno::EACCES => e
        puts "ERROR: Permission denied in writing the file #{file_path}"
        puts "Ensure that there is WRITE access on the directory containing #{file_path} - try running: sudo chmod +w /<<directory path>>"
        puts "ERROR @: #{e.backtrace[-2]}"
    end

end