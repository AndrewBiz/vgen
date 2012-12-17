#!/usr/bin/env ruby -w -U
# encoding: UTF-8
# (с) ANB Andrew Bizyaev Андрей Бизяев 

require_relative 'options'
require_relative '../anb/win_script'
require_relative '../anb/unix_script'
require_relative '../anb/anb'

require 'date'

module VGen 
  VERSION = "0.0.1"

  class Runner
    def initialize(argv)
      @options = Options.new(argv)
      p @options if @options.debug
    end #initialize
    
    def run 
      #Dir.chdir(@options.dir_source)
      fmask = File.join(@options.dir_source, "{#{@options.files_to_cnv * ","}}")
      xmask = File.join(@options.dir_source, "{#{@options.exclude_files * ","}}")
      

      script_name = %Q{vgen_#{DateTime.now.strftime('%Y%m%d-%H%M%S')}}
      case ANB::os
        when :windows then script = ANB::WinScript.new(script_name)
        else script = ANB::UnixScript.new(script_name)
      end  

      script.add_comment "*** vgen VERSION: #{VGen::VERSION} "
      script.add_comment "*** Input Parameters:"
      script.add_comment "    files_to_cnv  = #{@options.files_to_cnv}"
      script.add_comment "    dir_source    = #{@options.dir_source}"
      script.add_comment "    dir_target    = #{@options.dir_target}"
      script.add_comment "    exclude_files = #{@options.exclude_files}"
      script.add_comment "*** Masks:"
      script.add_comment "    fmask = #{fmask}"
      script.add_comment "    xmask = #{xmask}"
      script.add_comment ""
            
      script.add_options

      files_2_cnv = Dir.glob(fmask, File::FNM_CASEFOLD | File::FNM_DOTMATCH)
      taboo_files = Dir.glob(xmask, File::FNM_CASEFOLD | File::FNM_DOTMATCH)
      files_found = files_2_cnv.size
      files_excluded = (files_2_cnv - (files_2_cnv - taboo_files)).size
      
      files_2_cnv.each do |file|
        script.add_convert(file, @options.dir_target, taboo_files.include?(file))
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