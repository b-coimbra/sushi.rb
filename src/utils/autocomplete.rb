def autocompletion
  Readline.completion_append_character = ''
  # completion for commands
  comp = proc { |s| CMDS.keys.grep(/^#{Regexp.escape(s)}/im) }
  # completion for directories
  Readline.completion_proc = Proc.new { |str| Dir[str+'*'].grep(/^#{Regexp.escape(str)}/im) } || comp
end