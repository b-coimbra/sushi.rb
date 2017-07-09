#!/usr/bin/env ruby
# encoding: utf-8
system "title #{$0}"

$> << "\nwelcome back, #{ENV['COMPUTERNAME'].capitalize unless RUBY_PLATFORM[/linux|darwin|mac|solaris|bsd/im]} (´･ω･`)\n"

# setting ansi codes
BEGIN { trace_var :$Prompt, proc { |c| $> << "\e[33m┌─────┄┄ #{c} \e[33m\e[0m\e[1;35m░█\e[0m\e[1;46m #{Time.now.strftime('%H:%M')} \e[0m\e[1;35m█░\e[0m\n\e[33m└──┄\e[0m " } }  

# current directory
trace_var :$dir, proc { |loc| $dir = "\e[1;35m~/#{loc}\e[0m" }

def main
  $dir ||= __dir__.split(File::SEPARATOR)[-1]*?/

  trap("SIGINT") { throw :ctrl_c }

  catch :ctrl_c do
    $<.map do |input|
      i = input.to_s.strip
      # when a directory change is requested
      if i =~ /cd(?<dir>(\s(.*)+))/im 
        dir = $~[:dir].to_s.strip
        if !test ?e, dir # checking if it exists
          $> << "\e[31mNo folder named '#{dir}' in this directory!\e[0m\n"
          $Prompt = $dir if !has_git?
        else
          CMDS["cd"]::(dir) # changes directory
          $Prompt = "\e[1;35m#{$dir}\e[0m" unless has_git?
        end
      else
        # trigger command through native shell if not defined as a built-in
        !CMDS.has_key?(i) ? (system i) : (puts CMDS[i]::()) unless (i.nil? || i.empty? || i[/^[\r|\t]+$/m])
        # changing prompt state to the current directory
        $Prompt = $dir unless has_git?
      end
    end rescue NoMethodError abort "unknown command", main
  end
end

def has_git?
  $dir = Dir.pwd.split(File::SEPARATOR)[-1..-1]*?/

  if test ?e, '.git'
    if `git rev-parse --git-dir` =~ /^\.git$/im
      $Prompt = "git:#{`git show-branch`[/^\[.*\]/im]} #{$dir}"
    end
  end
end

def help
  print %{
    Usage: ruby shell.rb (or run the executable)

    Type any command into the terminal, that's it!
  }; exit 0
end

# Built-in commands
CMDS = {
  "cd"    => -> (dir = ENV['HOME']) { Dir.chdir dir },
  "date"  => -> { Time.now.strftime('%d/%m/%Y') },
  "exit"  => -> { $> << "bye (￣▽￣)ノ"; exit 0 },
  "clear" => -> { system 'cls' },
  "cmds"  => -> { CMDS.keys*?| },
  "path"  => -> { ENV['Path'] },
  "ls"    => -> { Dir['./*'] },
  "pwd"   => -> { Dir.pwd }
}

case ARGV[0]
when /(\-+|h)+/i then help # --help flag
else 
  $Prompt = $dir if !has_git?
  main if $0 == __FILE__
end

# check for exception when terminating
at_exit { abort $! ? "Uh.. you broke the shell ¯\\_(ツ)_/¯" : "bye (￣▽￣)ノ" }
