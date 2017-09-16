# adds padding and highlighting to folders
def ls
  Dir['*'].map { |file| "%-5s %-5s" % [ \
    ("\e[1;35m#{file}\e[0m" if File.directory?(file)), \
    (file if File.file?(file)) ] } 
end