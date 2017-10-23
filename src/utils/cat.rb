def cat(args)
  # redirect operator to append text on a file
  file, redirect, *content = args
  if !blank?(redirect)
    # copies the content of the 1st file to the 2nd one
    if File.file?(content[0].to_s)
      IO.copy_stream(file, content[0].to_s)
    else
      File.open(file, (redirect == '>' ? 'w+' : 'a+')) { |f| f << (content*?\s) } if redirect[/>+/m]
    end
  end
  # returns the contents of any file
  print "\n"
  File.open(args[0].to_s, 'r+').each_line.with_index { |line, i| 
    puts "#{((i+1).to_s.rjust(3)).bg_blue} #{line}" }
end
