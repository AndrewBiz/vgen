#!/usr/bin/env ruby -w -U
# encoding: UTF-8
# (с) ANB Andrew Bizyaev Андрей Бизяев 

require_relative "os_script"

module ANB 

  class UnixScript < OSScript
    
    def initialize basename='script'
      @name = File.join("#{basename}.sh")
      super()
    end #initialize
    
    def add_header
      @file.puts "#!/usr/bin/env bash"
      super()
    end #def

    def add_comment comment=""
      @file.puts "# #{comment}" #.encode("external")
    end #def
    
    def add_options
      add_comment "*** ffmpeg parameters:"
      @file.puts %Q{param="-R --progress"}
    end #def            

    def add_convert source, target, to_comment=false 
      # source=source_file, target=target_root_dir
      str = %Q{ffmpeg "#{source}" "#{File.join(target,"")}"}
      if to_comment
        add_comment str
      else  
        @file.puts str
      end   
    end #def
    
  end #class
end #module