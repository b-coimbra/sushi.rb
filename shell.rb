#!/usr/bin/env ruby
# encoding: UTF-8

system "title #{$0} - #{Dir.pwd}"

# setting prompt ansi codes
BEGIN { trace_var :$Prompt, proc { |c| $> << "\n\e[0;\n\e[33m┌─────┄┄ #{c} \e[33m\e[0m#{Time.now.strftime('%H:%M')}\n\e[33m└──┄\e[0m " } }

def main
  # terminate shell if ctrl+c
  trap("SIGINT") { throw :ctrl_c }

  catch :ctrl_c do
    # getting input from the console
    $<.map do |input|
      i = input.to_s.strip
      $dir = Dir.pwd.split('/')[-1..-1]*?/

      # checking if a change of directory was requested
      if i =~ /cd(?<dir>(\s(.*)+))/im
        dir = $~[:dir].to_s.strip

        # execute change if directory exists
        if !test(?e, dir)
          $> << "\e[31mNo folder named '#{dir}' in this directory!\e[0m\n"

          $Prompt = '' unless has_git?
        else
          $dir = dir

          CMDS["cd"]::(dir) # activates the built-in command to change directory

          $Prompt = "\e[1;35m~/#{dir}\e[0m" unless has_git?
        end
      else
        # if the input was not defined as a built-in command, then try to execute it through the native shell (unless input is blank)
        !CMDS.has_key?(i) ? (system i) : (puts CMDS[i]::()) unless (i.nil? || i.empty? || i[/\r/m]) == true

        # changing prompt state to the current directory
        $Prompt = "\e[1;35m~/#{$dir}\e[0m" unless has_git?
      end
    end rescue NoMethodError abort "unknown command"
  end
end

# check for git repository
def has_git?
  if test(?e, '.git')
    if (`git rev-parse --git-dir`) =~ /^\.git$/im
      $Prompt = "#{`git show-branch`[/^\[.*\]/im]} \e[1;35m~/#{$dir}\e[0m"
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
  "cd"   => -> (dir = __dir__) { Dir.chdir dir },
  "date" => -> { Time.now.strftime('%d/%m/%Y') },
  "exit" => -> { $> << "bye (￣▽￣)ノ"; exit 0 },
  "cls"  => -> { system 'cls' },
  "cmds" => -> { CMDS.keys*?| },
  "path" => -> { ENV['Path'] },
  "ls"   => -> { Dir["./*"] },
  "pwd"  => -> { Dir.pwd }
}

case ARGV[0]
when /(\-+|h)+/i then help # checking for --help flag
else 
  $Prompt = '' if !has_git?
  main if $0 == __FILE__
end

# checks if shell terminated with an error
at_exit { abort $! ? "Uh.. you broke the shell ¯\\_(ツ)_/¯" : "bye (￣▽￣)ノ" }