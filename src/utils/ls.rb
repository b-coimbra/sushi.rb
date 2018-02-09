def ls(flags)
  print "\n"
  case flags.to_s
  when '-l'
    show_info = true
    dir_size = 0
  end

  # adds padding and highlighting to folders / files
  if flags.to_s == '-la'
    Dir['*'].map { |file| puts "│ %-1s %-25s %-15s %s".cyan % [
      ("\r├──" + " #{file}".magenta if File.directory?(file)),
      ("\e[0m#{file}" if File.file?(file)),
      (File.size(file).to_filesize.to_s.green if !File.directory?(file) && show_info),
      (' │ ' + File.mtime(file).strftime("%D %H:%M") if !File.directory?(file) && show_info)] }
  else
    Dir['*'].each_slice(5).to_a.each do |file|
      file.each do |f|
        print "%-20s" % [
          File.directory?(f) ? ("%-20s".red % [f]) : f
        ]
      end
      puts "\n"
    end
  end
  # -l flag: calculates the total size of the folders / files
  file_size = ->(dir) {
    Dir['*'].map { |f| dir += File.size(f) }
    print "#{("│\n│\n└── "+dir.to_filesize.to_s).cyan} (#{Dir['*'].length} files)"
  }
  file_size.(dir_size) if flags.to_s == '-l'
end
