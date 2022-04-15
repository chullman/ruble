class FileHandler

    def initialize
      @file_path = ""
    end
  
    def try_file_open(file_path)
      @file_path = file_path
      begin
        file = File.open(@file_path)
  
        return file
  
      rescue Errno::ENOENT => e
  
        puts "ERROR: No such file \"#{@file_path}\" found"
        puts "ERROR @: #{e.backtrace[1]}"
        try_close_file(file)
  
      rescue Errno::EACCES => e
  
        puts "ERROR: Permission denied in opening the file #{@file_path}"
        puts "Ensure that everyone has read access to the file by running - chmod 444 #{@file_path}"
        puts "ERROR @: #{e.backtrace[1]}"
        try_close_file(file)       
       
      end
    end
  
    def try_file_read(file)
  
      file_contents = file.read
  
      try_close_file(file)
  
      file_contents.chomp!
  
      if file_contents.empty?
        raise ArgumentError, "ERROR: The file \"#{@file_path}\" is empty"
      end
  
      return file_contents
  
    end
  
    private 
    
    def try_close_file(file)
      file.close unless file.nil?
    end
  
end

  
