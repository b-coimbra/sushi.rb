# typed: true
# frozen_string_literal: true

require 'sorbet-runtime'
require 'readline'

require_relative 'command'
require_relative 'config-base'

Config.new

Readline.completion_append_character = "\t"

# command = Command.new(name: 'cat symbols.rb && ls ./ && history -n 3')

while input = Readline.readline('> ', true)
  next  if input == "\n"
  break if input == "q\n"

  begin
    command = Command.new(name: input)
    command.execute
  rescue Error => e
    puts e
  end
end
