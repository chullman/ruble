require 'prawn'
require 'date'

def try_generate_pdf(wordle, answers_storage, file_path)

        # 'Prawn' (PDF generation) documentation source: https://prawnpdf.org/manual.pdf (viewed 21/04/2022)

        pdf = Prawn::Document.new
        pdf.font_size(20) { pdf.text "Your Ruble results @ #{DateTime.now.strftime "%d/%m/%Y %H:%M"}" }

        pdf.stroke_horizontal_rule
        pdf.move_down 10
        
        pdf.font_size(20) { pdf.text "The Wordle was: \"#{wordle.to_s.strip.upcase}\"" }
        pdf.move_down 10

        green_fill_color = "33CC00"
        orange_fill_color = "FFC300"
        grey_fill_color = "CCCCCC"
        black_fill_color = "000000"

        box_width = 310
        box_height = 370

        pdf.bounding_box([0, pdf.cursor], width: box_width, height: box_height) do

            pdf.stroke_bounds

            x_pos = 10
            y_pos = box_height - 10

            answers_storage.answers.each do |answer_hash|

                for n in 1..5
                    if answer_hash[n][1] == :green
                        pdf.fill_color = green_fill_color
                    elsif answer_hash[n][1] == :orange
                        pdf.fill_color = orange_fill_color
                    elsif answer_hash[n][1] == :grey
                        pdf.fill_color = grey_fill_color
                    end
                    pdf.rectangle [x_pos, y_pos], 50, 50
                    pdf.fill
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

    rescue Errno::EACCES => e

        puts "ERROR"
        puts "ERROR: Permission denied in writing the file #{file_path}"
        puts "Ensure that there is WRITE access on the directory containing #{file_path} - try running: sudo chmod +w /<<directory path>>"
        puts "AND ensure that the file isn't already opened elsewhere"
        puts "ERROR @: #{e.backtrace[-2]}"
        puts "\n"

    else
        puts "Your Ruble results have been written to PDF file: #{file_path}"
    ensure
        return nil
    end

end