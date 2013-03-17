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

  end 
end 
