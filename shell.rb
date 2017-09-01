#!/usr/bin/env ruby
# encoding: utf-8
$: << File.join(__dir__, 'C:\\cygwin\\bin')

require 'fileutils'
require 'readline'

system "title #{$0}"

define_method(:is_windows) { !RUBY_PLATFORM[/linux|darwin|mac|solaris|bsd/im] }

define_method(:blank?) { |i| i.nil? || i.empty? || i[/^[\r|\t|\s]+$/m] }

define_method(:show_prompt_git?) { has_git? || $Prompt = $dir }

$> << "\nwelcome back#{', '+ENV['COMPUTERNAME'].capitalize if is_windows} (´･ω･`)\n"

# prompt ansi codes
BEGIN { trace_var :$Prompt, proc { |c| $> << "\n\e[33m┌─────┄┄ #{c} \e[33m\e[0m\n\e[33m└──┄\e[0m " } }  

# tracing directory changes
trace_var :$dir, proc { |loc| $dir = "\e[1;35m~/#{loc}\e[0m" }

$buffer = []

def main
  # current directory
  $dir ||= __dir__.split(File::SEPARATOR)[-1]*?/

  trap("SIGINT") { show_prompt_git? }

  catch :ctrl_c do
    while input = history
      # handling blank inputs
      show_prompt_git? if blank?(input)
      # trigger autocompletion
      autocompletion
      input.to_s.strip.split('&&').map do |i|
        # when a directory change is requested
        if i =~ /cd(?<dir>(\s(.*)+))/im
          change_dir($~[:dir].to_s.strip)
        else
          # trigger command through native shell if not defined as a built-in
          Thread.new {
            (!CMDS.has_key?(i) ? (system i) : (puts CMDS[i]::())) unless blank?(i)
          }.join
          # changing prompt state to the current directory
          show_prompt_git?
        end
        $buffer << i
      end
    end rescue NoMethodError abort "unknown command", main
  end
end

def history
  input = Readline.readline('', true)
  # read a line and append to history
  Readline::HISTORY.pop if input =~ /^\s*$/ or Readline::HISTORY.to_a[-2] == input
  input
end

def autocompletion
  Readline.completion_append_character = ''
  # completion for commands
  comp = proc { |s| CMDS.keys.grep(/^#{Regexp.escape(s)}/im) }
  # completion for directories
  Readline.completion_proc = Proc.new { |str| Dir[str+'*'].grep(/^#{Regexp.escape(str)}/im) } || comp
end

def change_dir(dir)
  if !test ?e, dir
    $> << "\e[31mNo folder named '#{dir}' in this directory!\e[0m\n"
    !has_git? && $Prompt = $dir 
  else
    CMDS["cd"]::(dir)
    has_git? || $Prompt = "\e[1;35m#$dir\e[0m"
  end
end

def has_git?
  $dir = Dir.pwd.split(File::SEPARATOR)[-1..-1]*?/

  if test ?e, '.git'
    if `git rev-parse --git-dir` =~ /^\.git$/im
      $Prompt = "git:#{`git show-branch`[/^\[.*\]/im]} #$dir"
    end
  end
end

def help
  print %{
    Usage: ruby shell.rb (or run the executable)

    Type any command into the terminal, use < to run the previous command, that's it!

    COMMANDS AVAILABLE:
    #{CMDS.keys*(?|)}
  }; exit 0
end

# Built-in commands
CMDS = {
  "mv"      =>-> (args) { file, loc = args.split("\s"); FileUtils.mv(file, loc) },
  "<"       =>-> { CMDS[$buffer[-1]]::() unless $buffer[-1].empty? },
  "rm"      =>-> (file) { FileUtils.rm_r(file, :verbose => true) },
  "touch"   =>-> (*files) { FileUtils.touch(files.split("\s")) },
  "mkdir"   =>-> (folder = "new") { FileUtils.mkdir(folder) },
  "clear"   =>-> { system is_windows ? 'cls' : 'clear'; nil },
  "cd"      =>-> (dir = ENV['HOME']) { Dir.chdir dir; nil },
  "date"    =>-> { Time.now.strftime('%d/%m/%Y') },
  "exit"    =>-> { $> << "bye (￣▽￣)ノ"; exit 0 },
  "update"  =>-> { `git pull origin master` },
  "cmds"    =>-> { CMDS.keys*(?\s"\s") },
  "path"    =>-> { ENV['Path'] },
  "history" =>-> { $buffer*?\n },
  "ls"      =>-> { Dir['*'] },
  "pwd"     =>-> { Dir.pwd }
}

class String
  define_method(:alias) { |cmd| CMDS.store("#{self}", -> { self[/q/i] ? eval(cmd) : system(cmd); nil }) }
end

# Command aliases
'c'   .alias 'cls'
'q'   .alias 'exit'
's'   .alias 'subl .'
'e'   .alias 'emacs -nw'
'o'   .alias 'explorer .'
'off' .alias 'shutdown -s -f -t 0'
'att' .alias 'sudo apt-get update'

case $*[0]
when /(\-+|h)+/i then help # --help flag
else 
  $Prompt = $dir if !has_git?
  main if $0 == __FILE__
end

# check for exception when terminating
at_exit { abort $! ? "Uh.. you broke the shell ¯\\_(ツ)_/¯" : "bye (￣▽￣)ノ" }
