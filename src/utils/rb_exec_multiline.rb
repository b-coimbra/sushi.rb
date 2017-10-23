def rb_exec_mult
  commands = []
  num = 0 
  loop { print "#{(num += 1).to_s.rjust(3).bg_red} "; expr = gets.chomp; expr != "~" ? (commands << expr if !blank?(expr)) : break }
  eval(commands.join("\n"))
end