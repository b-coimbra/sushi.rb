#!/usr/bin/env ruby

def bar(opt)
  nircmd_path = File.expand_path('C:/nircmd')

  if opt =~ /^[s]/
    system "#{nircmd_path}/nircmd.exe win show class Shell_TrayWnd"
  elsif opt =~ /^[h]/
    system "#{nircmd_path}/nircmd.exe win hide class Shell_TrayWnd"
  else
    puts 'USAGE: bar [s|h]'
  end
end