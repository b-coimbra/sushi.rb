def cat(files)
  print "\n"
  files.each { |f| 
    File.open(f, 'r+').each_line.with_index { |line, i| 
      puts "#{((i+1).to_s.rjust(3)).bg_blue} #{line}"
    } }; nil
end
