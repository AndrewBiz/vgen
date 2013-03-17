#!/usr/bin/env ruby -w -U
# encoding: UTF-8
# (с) ANB Andrew Bizyaev Андрей Бизяев

require_relative "../anb/win_script"

module VGen

  class FfmpegWinScript < ANB::WinScript

    def add_options
      add_comment "*** you can add options to xcopy (e.g. param=/N):"
      @file.puts %Q{set param=}
    end #def

    def add_convert source, target, to_comment=false, options="%param%"
      # source=source_file, target=target_root_dir
      target_dir = File.join(target, File.dirname(source), "")
      str = %Q{xcopy "#{win_separator(source)}" "#{win_separator(target_dir)}" #{options}}
      if to_comment
        add_comment str
      else
        @file.puts str
      end
    end #def
  end 
end 
