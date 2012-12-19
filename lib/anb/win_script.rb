#!/usr/bin/env ruby -w -U
# encoding: UTF-8
# (с) ANB Andrew Bizyaev Андрей Бизяев

require_relative "os_script"

module ANB

  class WinScript <OSScript

    def initialize basename
      @name = File.join("#{basename}.cmd")
      super()
    end #initialize

    def add_header
      @file.puts "@echo off"
      super()
    end #def

    def add_comment comment=""
      @file.puts "rem #{comment}" #.encode("external")
    end #def

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

    private

    def win_separator path
      path.gsub(/#{"/"}/, "\\")
    end #def
  end #class
end #module