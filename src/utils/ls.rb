def ls
  dir_size = 0
  print "\n"
  # adds padding and highlighting to folders / files
  Dir['*'].map { |file| puts "│ %-1s %-25s %-15s %s".cyan % [ \
    ("\r├──" + " #{file}".magenta if File.directory?(file)), \
    ("\e[0m#{file}" if File.file?(file)),
    (File.size(file).to_filesize.to_s.green if !File.directory?(file)),
    (' │ ' + File.mtime(file).strftime("%D %H:%M") if !File.directory?(file))] }
  # calculates the total size of the folders / files
  Dir['*'].map { |f| dir_size += File.size(f) }
  print "\n#{dir_size.to_filesize.to_s.green} (#{Dir['*'].length} files)"
end