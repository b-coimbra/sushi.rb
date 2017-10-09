def help
  print %{
    Usage: ruby shell.rb (or run the executable)

    Type any command into the terminal, use < to run the previous command, that's it!

    COMMANDS AVAILABLE:
    #{CMDS.keys.sort_by(&:downcase)*(?\s"| ").yellow}
  }; exit 0
end
