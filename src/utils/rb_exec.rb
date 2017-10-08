def rb_exec(*cmds)
  cmds = cmds*?\s
  if !blank?(cmds)
    begin
      return eval cmds
    rescue SyntaxError => e
      print e
    end
  else
    puts "example: > puts 'hello'.red"
  end
end