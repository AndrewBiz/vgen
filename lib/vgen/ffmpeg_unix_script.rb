#!/usr/bin/env ruby -w -U
# encoding: UTF-8
# (с) ANB Andrew Bizyaev Андрей Бизяев

require_relative "../anb/unix_script"

module VGen

  class FfmpegUnixScript < ANB::UnixScript

    def add_options in_dir, out_dir
      add_comment "*** ffmpeg parameters:"
      add_comment "* Input prepocessor (e.g. -ss 00:00:00.5 to avoid trash start frames):"
      @file.puts %Q{preprocessor="-ss 00:00:00.5"}
      add_comment "* Video filter:"

      # 480p (~640x480)
      # @file.puts %Q{vfilter="-vf \\"yadif=0:-1:0, scale='trunc(oh*a/2)*2:480'\\""}
      # add_comment "* Video filter with cropping:"
      # @file.puts %Q{#vfilter="-vf \\"crop=in_w-2*32:in_h-2*24, yadif=0:-1:0, scale='trunc(oh*a/2)*2:480'\\""}

      # 720p (~1280x720)
      @file.puts %Q{vfilter="-vf \\"yadif=0:-1:0, scale='trunc(oh*a/2)*2:720'\\""}
      add_comment "* Video filter with cropping:"
      @file.puts %Q{#vfilter="-vf \\"crop=in_w-2*32:in_h-2*24, yadif=0:-1:0, scale='trunc(oh*a/2)*2:720'\\""}

      # 1080p (1920x1080)

      add_comment "* Audio filter:"
      @file.puts %Q{afilter="-af 'aformat=sample_rates=22050|44100|48000'"}
      add_comment "* Video coder: crf=21 - optimal for web, crf=27 - for small old-foto video"
      @file.puts %Q{vcodec="-r 25 -vcodec libx264 -f mp4 -vprofile high -preset slower -x264opts crf=21 -threads 0"}
      add_comment "* Audio coder:"
      @file.puts %Q{acodec="-b:a 128k"}
      add_comment "* Metadata transormation:"
      @file.puts %Q{metadata="-map_metadata g"}
      add_comment "* Output file parameters:"
      @file.puts %Q{out_dir="#{File.join(in_dir, out_dir)}"}  #relative path
      @file.puts %Q{out_ext="_web_.mp4"}
      @file.puts %Q{}
    end #def

    def add_convert in_dir, in_file, base, dto="", to_comment=false, echo="***"
      script = []
      script << %Q{echo "#{echo}"}
      script << %Q{in_file="#{File.join(in_dir, in_file)}"}
      script << %Q{out_file=$out_dir"/#{base}"$out_ext}
      if dto.empty?
        script << %Q{#metadata="-metadata:g creation_time='2000-01-01 10:00:00'" #to explicitely set creation date}
      else
        script << %Q{metadata="-metadata:g creation_time='#{dto}'" #to explicitely set creation date}
      end
      script << %Q{command_line="ffmpeg $preprocessor -i \\"$in_file\\" $vfilter $vcodec $metadata $afilter $acodec \\"$out_file\\""}
      script << %Q{echo "*** START TIME: "`date "+%Y-%m-%d %H:%M:%S"`}
      script << %Q{echo $command_line}
      script << %Q{eval $command_line}
      script << %Q{echo "*** FINISH TIME: "`date "+%Y-%m-%d %H:%M:%S"`}
      script.each { |l| to_comment ? add_comment(l) : @file.puts(l) }
      @file.puts %Q{}
    end #def

  end #class
end #module
