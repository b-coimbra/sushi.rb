# typed: true
# frozen_string_literal: true

require 'sorbet-runtime'

require_relative 'command'
require_relative 'config-base'

# command = Command.new(name: 'cat symbols.rb && ls ./ && history -n 3')

Config.new

loop do
  input = gets

  next  if input == "\n"
  break if input == 'q'

  begin
    command = Command.new(name: input)
    command.execute
  rescue Error => e
    puts e
  end
end
