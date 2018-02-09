require 'io/console'

def screenfetch
  rows, columns = $stdout.winsize
  print %{
     .     '     ,
      _________
   _ /_|_____|_\\ _   @#{ENV['COMPUTERNAME'].capitalize}
     '. \\   / .'     OS: #{RUBY_PLATFORM}
       '.\\ /.'       Shell: sushi.rb
         '.'
  }.red
end
