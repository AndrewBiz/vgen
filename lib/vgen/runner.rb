#!/usr/bin/env ruby -w -U
# encoding: UTF-8
# (с) ANB Andrew Bizyaev Андрей Бизяев 

require_relative 'options'
require_relative '../anb/win_script'
require_relative '../anb/unix_script'
require_relative '../anb/anb'

require 'date'

module VGen 
  VERSION = "0.3.0"

  class Runner
    def initialize(argv)
      @options = Options.new(argv)
      p @options if @options.debug
    end #initialize

    def run
      # initializing
      fmask = File.join(@options.dir_source, "{#{@options.files_to_cnv * ","}}")
      xmask = File.join(@options.dir_source, "{#{@options.exclude_files * ","}}")
      files_2_cnv = Dir.glob(fmask, File::FNM_CASEFOLD | File::FNM_DOTMATCH)
      taboo_files = Dir.glob(xmask, File::FNM_CASEFOLD | File::FNM_DOTMATCH)
      files_found = files_2_cnv.size
      files_excluded = (files_2_cnv - (files_2_cnv - taboo_files)).size
      out_dir = @options.dir_target

      # generating script
      case ANB::os
      when :windows
        script = ANB::WinScript.new(@options.script_name)
      else
        script = ANB::UnixScript.new(@options.script_name)
      end

      script.add_comment "*** vgen VERSION: #{VGen::VERSION} "
      script.add_comment "*** Input Parameters:"
      script.add_comment "    files_to_cnv  = #{@options.files_to_cnv}"
      script.add_comment "    dir_source    = #{@options.dir_source}"
      script.add_comment "    dir_target    = #{@options.dir_target}"
      script.add_comment "    exclude_files = #{@options.exclude_files}"
      script.add_comment ""
      script.add_options out_dir


      i = 0
      files_2_cnv.each do |file|
        i += 1
        ext = File.extname file
        in_file = File.basename file
        in_dir = File.dirname file

        # date-time-original trying to get from filename:
        rg = '(?<year>\d\d\d\d)(?<month>\d\d)(?<day>\d\d)\-(?<hour>\d\d)(?<min>\d\d)(?<sec>\d\d)'
        if ( m = Regexp.new(rg).match(in_file) ) 
          dto = "#{m[:year]}-#{m[:month]}-#{m[:day]} #{m[:hour]}:#{m[:min]}:#{m[:sec]}"
        else 
          dto = ""
        end  
        script.add_convert(in_dir, in_file, "#{File.basename(file,ext)}",
               dto, taboo_files.include?(file), 
               "********** PROCESSING #{i} OF #{files_found} **********")
      end
      #bottom
      script.add_comment
      script.add_comment "*** Statistics:"
      script.add_comment "    +Files found:    #{files_found}"
      script.add_comment "    -Files excluded: #{files_excluded}"
      script.add_comment "    =Files to convert:  #{files_found - files_excluded}"
      script.close
      puts "Script #{script.name} generated, files found: #{files_found}, files excluded: #{files_excluded}"
    end #run

  end #class
end #module
