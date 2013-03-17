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

    private

    def win_separator path
      path.gsub(/#{"/"}/, "\\")
    end

  end
end
