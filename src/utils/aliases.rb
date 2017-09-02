require_relative 'cmds'

# Stores new commands into the Built-in array as aliases
class String
  define_method(:alias) { |cmd| CMDS.store(self.to_sym, -> { self[/q/i] ? eval(cmd) : system(cmd); nil }) }
end

# Command aliases
'c'   .alias 'cls'
'q'   .alias 'exit'
's'   .alias 'subl .'
'att' .alias 'git pull'
'e'   .alias 'emacs -nw'
'o'   .alias 'explorer .'
'off' .alias 'shutdown -s -f -t 0'