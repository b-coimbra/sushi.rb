def help
  print %{
    shell-rb is a custom shell with unix features written in Ruby.

    Type any command into the terminal, or write your own, that's it!

    COMMANDS AVAILABLE:\n\n}
  CMDS.collect { |key, val| puts "%-20s %s" % [key.to_s.cyan, val[1].to_s.gsub(/\{\:description\=\>|\"|\}/m,'')] }
  puts "\nPress [ENTER] to continue...".cyan
  Core::new.main
end
