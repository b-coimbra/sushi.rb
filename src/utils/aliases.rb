require_relative 'cmds'

## Stores new commands into the Built-in array as aliases
class String
  define_method(:alias) { |cmd, des| CMDS.store(self.to_sym,
    [-> { self[/q/i] \
        ? eval(cmd)  \
        : system(cmd); nil },
    :description => "#{"[alias = #{cmd.blue}]".yellow} #{des}" ]) }
end
