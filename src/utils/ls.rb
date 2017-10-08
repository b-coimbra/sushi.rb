# adds padding and highlighting to folders
def ls
  print "\n"
  Dir['*'].map { |file| "│ %-1s %s".cyan % [ \
    ("\r├──" + " #{file}".magenta if File.directory?(file)), \
    ("+ \e[0m#{file}" if File.file?(file)) ] }
end