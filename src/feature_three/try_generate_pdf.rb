require 'prawn'
require 'date'

using ColorizeStringPatches

def try_generate_pdf(wordle, answers_storage, file_path)

        # 'Prawn' (PDF generation) documentation source: https://prawnpdf.org/manual.pdf (viewed 21/04/2022)

        pdf = Prawn::Document.new

        # I used A LOT of trial-and-error when coding all the below to try and get all the output displayed neatly in the generated PDF

        pdf.font_size(20) { pdf.text "Your Ruble results @ #{DateTime.now.strftime "%d/%m/%Y %H:%M"}" }

        pdf.stroke_horizontal_rule
        pdf.move_down 10
        
        pdf.font_size(20) { pdf.text "The Wordle was: \"#{wordle.to_s.strip.upcase}\"" }
        pdf.move_down 10

        # These are the hex colour values for the rectangles behind each letters
        green_fill_color = "33CC00"
        orange_fill_color = "FFC300"
        grey_fill_color = "CCCCCC"

        # The hex colour value for the letters text
        black_fill_color = "000000"

        box_width = 310
        box_height = 370

        # According to https://prawnpdf.org/manual.pdf a 'bounding_box' holds every thing inside it (in our case, the user's results)
        # relative to the boxes position, so this helps with layout of all content

        pdf.bounding_box([0, pdf.cursor], width: box_width, height: box_height) do

            pdf.stroke_bounds

            # Everything inside the box is positioned ABSOLUTELY (relative to bounding_box) using x and y coords values
            # Again, a lot of trial and error to get everything aligned and sized perfectly 

            x_pos = 10
            y_pos = box_height - 10

            # For every user's guesses (up to 6 guesses)...
            answers_storage.answers.each do |answer_hash|

                # For every letter in the guess (1 to 5)
                for n in 1..5
                    # fill_color will be the colour of the rectangle behind the letter
                    if answer_hash[n][1] == :green
                        pdf.fill_color = green_fill_color
                    elsif answer_hash[n][1] == :orange
                        pdf.fill_color = orange_fill_color
                    elsif answer_hash[n][1] == :grey
                        pdf.fill_color = grey_fill_color
                    end
                    # Position and generate the rectable
                    pdf.rectangle [x_pos, y_pos], 50, 50
                    pdf.fill
                    # Change the fill colour to black to color the letter text, and position in inside the rectangle
                    pdf.fill_color = black_fill_color
                    pdf.draw_text answer_hash[n][0].to_s.upcase, at: [x_pos+20, y_pos-30]
                    x_pos += 60
                end

                x_pos = 10
                y_pos -= 60
            end
   
        end

    begin

        pdf.render_file file_path

    # Will be raised if there is no WRITE access in the 'src/' directory to generate the PDF file into
    # TO DO: provide the option to retry generate the PDF file if they manage to fix the permissions error on their system
    rescue Errno::EACCES => e

        puts "\n"
        puts "ERROR: Permission denied in writing the file #{file_path}"
        puts "Ensure that there is WRITE access on the directory containing #{file_path} - try running: sudo chmod +w /<<directory path>>"
        puts "AND ensure that the file isn't already opened elsewhere"
        puts "ERROR @: #{e.backtrace[-2]}"
        puts "\n"

    else
        puts "\n"
        puts "Your Ruble results have been written to PDF file: '#{file_path}' in the 'src/' directory".color(:green)
        puts "\n"
    ensure
        return nil
    end

end