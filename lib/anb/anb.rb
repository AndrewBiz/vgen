#!/usr/bin/env ruby -w -U
# encoding: UTF-8
# (с) ANB Andrew Bizyaev Андрей Бизяев
require 'rbconfig'

module ANB

  # determine OS
  def self.os (os_string = RbConfig::CONFIG['host_os'])
    case os_string
      when /darwin/ then :mac
      when /linux/ then :linux
      when /w32/ then :windows
      else :unknown
    end
  end

end #module