def todo(args)
  path = File.dirname(__FILE__) + '/todo/to-do.txt'

  show_todo = -> {
    File.open(path, 'r+').each_line.with_index { |line, i| puts "#{((-~i).to_s + '.').bg_red} #{line}" }
  }

  done = []
  option, *msg = args
  msg = msg*?\s

  case option
  when /add/i
    File.open(path, 'a+') { |f| f.puts msg }
  when /show/i
    show_todo.()
  when /remove/i
    File.open(path, 'a+').each_line.with_index { |line, i| File.open(path, 'w') { |f| 
      f.puts(line) if msg.to_i == -~i } }
  when /clear/
    File.open(path, 'w+') { |f| f << nil }
  else
    show_todo.()
  end
end
