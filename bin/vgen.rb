#!/usr/bin/env ruby -w -U
# encoding: UTF-8
# (с) ANB Andrew Bizyaev Андрей Бизяев 
require_relative '../lib/vgen/runner'

begin #*** GLOBAL BLOCK  
  #p ARGV
  argv_utf8 = ARGV.map{|a| a.encode("internal", "filesystem")}   #workaround for win32
  runner = VGen::Runner.new(argv_utf8) 
  runner.run

rescue SignalException => e
  $stderr.puts "Exit on user interrupt Ctrl-C"
  exit(-1)

rescue Exception => e
  $stderr.puts e.message
  exit(-1)

end # *** GLOBAL BLOCK
