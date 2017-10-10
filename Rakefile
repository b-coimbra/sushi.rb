task :default => 'run'

desc "Run shell"
task :run do
  ruby 'src/main.rb'
end

desc "Builds executable file"
task :build do
  puts 'Creating executable file...'
  sh 'ocra src --output bin/shell.exe'
end

desc "Updates the shell"
task :update do
  puts "Updating rb-shell..."
  sh 'git pull origin master'
end