#!/usr/bin/env ruby
# encoding: utf-8

system "title #{$0}"

# setting prompt ansi codes
BEGIN { trace_var :$Prompt, proc { |c| $> << "\n\e[0;\n\e[33m┌─────┄┄ #{c} \e[33m\e[0m\e[1;35m░█\e[0m\e[1;46m #{Time.now.strftime('%H:%M')} \e[0m\e[1;35m█░\e[0m\n\e[33m└──┄\e[0m " } }  

# current directory
trace_var :$dir, proc { |loc| $dir = "\e[1;35m~/#{loc}\e[0m" }

def main
  $dir ||= __dir__.split(File::SEPARATOR)[-1]*?/

  trap("SIGINT") { throw :ctrl_c }

  catch :ctrl_c do
    # getting input from the console
    $<.map do |input|
      i = input.to_s.strip

      # checking if a change of directory was requested
      if i =~ /cd(?<dir>(\s(.*)+))/im
        dir = $~[:dir].to_s.strip

        # execute change if directory exists
        if !test(?e, dir)
          $> << "\e[31mNo folder named '#{dir}' in this directory!\e[0m\n"

          $Prompt = $dir if !has_git?
        else
          CMDS["cd"]::(dir) # activates the built-in command to change directory

          $Prompt = "\e[1;35m#{$dir}\e[0m" unless has_git?
        end
      else
        # if the input was not defined as a built-in command, then try to execute it through the native shell (unless input is blank)
        !CMDS.has_key?(i) ? (system i) : (puts CMDS[i]::()) unless (i.nil? || i.empty? || i[/^[\r|\t|\s]+$/m])

        # changing prompt state to the current directory
        $Prompt = $dir unless has_git?
      end
    end rescue NoMethodError abort "unknown command", main
  end
end

# check for git repository
def has_git?
  $dir = Dir.pwd.split(File::SEPARATOR)[-1..-1]*?/

  if test(?e, '.git')
    if (`git rev-parse --git-dir`) =~ /^\.git$/im
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
  "cd"   => -> (dir = ENV['HOME']) { Dir.chdir dir },
  "date" => -> { Time.now.strftime('%d/%m/%Y') },
  "exit" => -> { $> << "bye (￣▽￣)ノ"; exit 0 },
  "cls"  => -> { system 'cls' },
  "cmds" => -> { CMDS.keys*?| },
  "path" => -> { ENV['Path'] },
  "ls"   => -> { Dir['./*'] },
  "pwd"  => -> { Dir.pwd }
}

case ARGV[0]
when /(\-+|h)+/i then help # checking for --help flag
else 
  $Prompt = $dir if !has_git?
  main if $0 == __FILE__
end

# checks if shell terminated with an error
at_exit { abort $! ? "Uh.. you broke the shell ¯\\_(ツ)_/¯" : "bye (￣▽￣)ノ" }
