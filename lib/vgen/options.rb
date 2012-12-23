#!/usr/bin/env ruby -w -U
# encoding: UTF-8
# (с) ANB Andrew Bizyaev Андрей Бизяев
require 'optparse'

module VGen
  class Options
    attr_reader :dir_source, :dir_target, :files_to_cnv, :exclude_files
    attr_reader :debug, :rest

    DEF_FILES_TO_CNV = ["*.mov", "*.dv", "*.avi", "*.mpg", "*.mts", "*.mp4"]

    def initialize(argv)
      parse(argv)
      @dir_source ||= "."
      @dir_target ||= @dir_source
      @files_to_cnv ||= DEF_FILES_TO_CNV
      @exclude_files ||= []
      @debug ||= false
    end #def

  private
    def parse(argv)
      OptionParser.new do |opts|
        opts.banner = "Usage: vgen [-s SOURCE_DIR] [-t TARGET_DIR] [-f file1[,file2]...] [-x x1[,x2]...] [-D]"
        opts.separator ""
        opts.separator "Generates script to convert files with given masks file1,file2 etc. from SOURCE_DIR to TARGET_DIR using ffmpeg."
        opts.separator ""

        opts.separator "Specific options:"

        @dir_source = nil
        opts.on("-s", "--dir_source DIR", String, "Source DIR, default is '.'") do |val|
          @dir_source = val
        end

        @dir_target = nil
        opts.on("-t", "--dir_target DIR", String, "Target DIR, default is Source DIR") do |val|
          @dir_target = val
        end

        @files_to_cnv = nil
        opts.on("-f", "--files_to_cnv f1,f2,f3", Array, "Masks of files to be copied",
                "If no file is defined the mask '#{DEF_FILES_TO_CNV * ","}' is used by default") do |val|
          @files_to_cnv = val
        end

        @exclude_files = nil
        opts.on("-x", "--exclude_files x1,x2,x3", Array, "Exclude file mask. These files won't be copied" ) do |val|
          @exclude_files = val
        end

        @debug = nil
        opts.on("-D", "--debug", "Debug mode") do |val|
          @debug = val
        end

        opts.separator ""
        opts.separator "Common options:"

        # No argument, shows at tail.  This will print an options summary.
        opts.on_tail("-h", "-?", "--about", "--help", "Show this message") do
          puts opts
          exit
        end

        opts.on_tail("-v", "--version", "--ver", "Show version") do
          puts "vgen.rb version: #{VGen::VERSION}"
          exit
        end

        begin
          argv = ["-h"] if argv.empty?
          @rest = opts.parse!(argv)

        rescue OptionParser::ParseError => e
          STDERR.puts e.message, "\n", opts
          exit(-1)
        end
      end
    end #def

  end #class
end #module
