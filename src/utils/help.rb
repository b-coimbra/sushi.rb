def help
  print %{
    sushi.rb (Simple Unix SHell In RuBy) is a custom shell with unix features written in Ruby.

    Just type any command into the terminal, or write your own, that's it!

    COMMANDS AVAILABLE:\n\n}
  CMDS.collect { |key, val| puts "%-20s %s %s" % [key.to_s.cyan, val[1].values[1].to_s.yellow, val[1].values[0]] }
  puts "\nPress [ENTER] to continue...".cyan
  Core.main
end