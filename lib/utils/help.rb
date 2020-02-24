# frozen_string_literal: true

require_relative '../help'

def help(*args)
  command, = *args

  help = Help.new

  return help.sheet if command.nil?

  help.seek(command)
end

__END__
method: help
description: describes all commands
