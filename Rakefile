task :default => 'run'

desc "Run shell"
task :run do
  ruby 'src/sushi.rb'
end

desc "Builds executable file"
task :build do
  puts 'Creating executable file...'
  sh 'ocra src --output bin/shell.exe'
end

desc "Updates the shell"
task :update do
  puts "Updating sushi.rb..."
  sh 'git pull origin master'
end

desc "Installs dependencies"
task :instal do
  puts "Installing the dependencies, if there's any.."
  ruby './dependencies.rb'
end