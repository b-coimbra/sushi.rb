require_relative 'cmds'

## Stores new commands into the Built-in array as aliases
class String
  define_method(:alias) { |cmd, des| CMDS.store(self.to_sym,
    [-> { self[/q/i] \
        ? eval(cmd)  \
        : system(cmd); nil },
    :description => des.to_s ]) }
end

###  Command aliases
##   alias / command / description
'c'   .alias 'cls', 'clears buffer'
'q'   .alias 'exit', 'quits shell'
's'   .alias 'subl .', 'sublime'
'att' .alias 'git pull', 'update'
'e'   .alias 'emacs -nw', 'emacs'
'o'   .alias 'explorer .', 'open dir'
# 'off' .alias 'shutdown -s -f -t 0', 'shutdown'