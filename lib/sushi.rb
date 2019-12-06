#!/usr/bin/env ruby

require_relative 'command'

begin
  command = Command.new
  command.name = "cat && ls ./ && cowcow"
  command.execute
rescue => error
  puts error.message
end

# loop do
#   command.name = gets.chomp

#   break if command.name == 'q'

#   # command.execute
# end

# class Sushi
#   def initialize
#   end
# end

