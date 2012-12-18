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
      add_comment "* Video filter:"
      @file.puts %Q{vfilter="-vf \\"yadif=0:-1:0, scale='trunc(oh*a/2)*2:480'\\""}
      add_comment "* Audio filter:"
      @file.puts %Q{afilter="-af \\"aformat=sample_rates='22050,44100,48000' \\""}
      add_comment "* Video coder: crf=21 - optimal for web, crf=27 - for small old-foto video"
      @file.puts %Q{vcodec="-r 25 -vcodec libx264 -f mp4 -vprofile high -preset slower -x264opts crf=21 -threads 0"}
      add_comment "* Audio coder:"
      @file.puts %Q{acodec="-b:a 128k"}
      add_comment "* Metadata transormation:"
      @file.puts %Q{metadata="-map_metadata g"}
      @file.puts %Q{}
    end #def            

    def add_convert in_dir, in_file, out_dir, out_file, to_comment=false, echo="********************" 
      script = []
      script << %Q{echo "#{echo}"}
      script << %Q{in_file="#{File.join(in_dir, in_file)}"}
      script << %Q{out_file="#{File.join(out_dir, out_file)}"}
      script << %Q{command_line="ffmpeg -i $in_file $vfilter $vcodec $metadata $afilter $acodec $out_file"}
      script << %Q{echo $command_line}
      script << %Q{eval $command_line}
      script.each { |l| to_comment ? add_comment(l) : @file.puts(l) }
      @file.puts %Q{}   
    end #def
    
  end #class
end #module