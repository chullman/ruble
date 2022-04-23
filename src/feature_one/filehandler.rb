class FileHandler

    def initialize
      @file_path = ""
    end
  
    def try_file_open(file_path)
      @file_path = file_path
      begin
        file = File.open(@file_path)
  
        return file
  
      # Handle if the file cannot be found at all
      rescue Errno::ENOENT => e
  
        puts "\n"
        puts "ERROR: No such file \"#{@file_path}\" found"
        puts "ERROR @: #{e.backtrace[1]}"
        puts "\n"
        # For good memory practice, attempt to close the file if for some reason it still gets opened
        try_file_close(file)
        return nil
  
      rescue Errno::EACCES => e
  
        puts "\n"
        puts "ERROR: Permission denied in opening the file #{@file_path}"
        puts "Ensure that everyone has read access to the file by running - sudo chmod +r #{@file_path}"
        puts "ERROR @: #{e.backtrace[1]}"
        puts "\n"
        try_file_close(file)
        return nil       
       
      end
    end
  
    def try_file_read(file)
  
      file_contents = file.read
  
      try_file_close(file)
  
      file_contents.chomp!
  
      if file_contents.empty?
        raise ArgumentError, "\nERROR: The file \"#{@file_path}\" is empty\n"
      end
  
      return file_contents
  
    end
  
    private 
    
    def try_file_close(file)
      file.close unless file.nil?
    end
  
end

  
