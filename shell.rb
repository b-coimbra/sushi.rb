#!/usr/bin/env ruby
# encoding: utf-8
## One-file version of rb-shell, for testing
$: << File.join(__dir__, 'C:\\cygwin\\bin')

require 'fileutils'
require 'readline'
require 'win32ole'

system "title rb-shell && cls"

define_method(:is_windows) { !RUBY_PLATFORM[/linux|darwin|mac|solaris|bsd/im] }

define_method(:blank?) { |i| i.nil? || i.empty? || i[/^[\r|\t|\s]+$/m] }

define_method(:show_prompt_git?) { has_git? || $Prompt = $dir }

$> << "\nwelcome back#{', '+ENV['COMPUTERNAME'].capitalize if is_windows}!\n"

# prompt ansi codes
BEGIN { trace_var :$Prompt, proc { |dir| $> << "\n\e[36m┌──────── #{dir} \e[36m\e[0m\n\e[36m└────\e[0m " } }

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
      input.to_s.strip.split('&&').map do |line|
        # when a directory change is requested
        if line =~ /cd(?<dir>(\s(.*)+))/im
          change_dir($~[:dir].to_s.strip)
        else
          command, *args = line.split("\s")
          # trigger command through native shell if not defined as a built-in
          Thread.new {
            if !CMDS.has_key?(command.to_sym)
              system line
            else
              puts args.empty? ? CMDS[command.to_sym]::() : CMDS[command.to_sym]::(args)
            end unless blank?(line)
          }.join
          # changing prompt state to the current directory
          show_prompt_git?
        end
        $buffer << line
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
    CMDS[:cd]::(dir)
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

def cowsay(sentence)
_ = <<COWSAY
 _#{'_'*sentence.length}_
< #{sentence} >
 -#{'-'*sentence.length}-
      \\   ^__^
       \\  (oo)\\_______
          (__)\\       )/\\
              ||----w |
              ||     ||
COWSAY
end

# adds padding and highlighting to folders
def ls
  print "\n"
  Dir['*'].map { |file| "%-5s %-5s" % [ \
    ("\e[1;35m + #{file}\e[0m" if File.directory?(file)), \
    (file if File.file?(file)) ] } 
end

# evaluates common mathematical expressions
def calc(expr)
  return eval(expr \
  .gsub(/\[/,'(') \
  .gsub(/\]/,')') \
  .gsub(/(add|plus)/i,'+') \
  .gsub(/(modulus|mod)/i,'%') \
  .gsub(/(subtract|minus)/i,'-') \
  .gsub(/(\^|power by|pow)/i,'**') \
  .gsub(/(divided by|div|÷)/i,'/') \
  .gsub(/(×|∙|multiplied by|mult)/i,'*') \
  .gsub(/[^0-9\s\-\(\)^*+\/]/,'')) rescue return false
end

def run(cmd)
  (print 'Example: run google ruby programming'; return) if blank?(cmd)
  shell = WIN32OLE.new("Wscript.Shell")
  link, *keystrokes = cmd.split("\s")
  link = "www.#{link}.com"
  link =~ /www\.(.*)\.com/i
  title = $1.capitalize
  case RbConfig::CONFIG['host_os']
  when /mswin|mingw|cygwin/im
      system "start #{link}"
  when /darwin/im
      system "open #{link}"
  when /linux|bsd/im
      system "xdg-open #{link}"
  end
  sleep 4
  (shell.Run(title); sleep 0.5) while !shell.AppActivate(title)
  shell.SendKeys(keystrokes*?\s + "{ENTER}")
  print "Sent: \e[31m#{keystrokes*?\s}\e[0m to: #{link}"
end

# Built-in commands
CMDS = {
  :<       =>-> { CMDS[$buffer[-1].to_sym]::() unless $buffer[-1].empty? },
  :mv      =>-> (*args) { file, loc = args; FileUtils.mv(file, loc) },
  :rm      =>-> (file) { FileUtils.rm_r(file, :verbose => true) },
  :calc    =>-> (*expression) { calc(expression.join("\s")) },
  :mkdir   =>-> (folder = "new") { FileUtils.mkdir(folder) },
  :clear   =>-> { system is_windows ? 'cls' : 'clear'; nil },
  :cd      =>-> (dir = ENV['HOME']) { Dir.chdir dir; nil },
  :cowsay  =>-> (*phrase) { cowsay(phrase.join("\s")) },
  :touch   =>-> (*files) { FileUtils.touch(files) },
  :date    =>-> { Time.now.strftime('%d/%m/%Y') },
  :exit    =>-> { $> << "bye (￣▽￣)ノ"; exit 0 },
  :echo    =>-> (*str) { print str*?\s },
  :update  =>-> { `git pull origin master` },
  :run     =>-> (*args) { run(args*?\s) },
  :cmds    =>-> { CMDS.keys*(?\s"\s") },
  :path    =>-> { ENV['Path'] },
  :history =>-> { $buffer*?\n },
  :pwd     =>-> { Dir.pwd },
  :ls      =>-> { ls }
}

class String
  define_method(:alias) { |cmd| CMDS.store(self.to_sym, -> { self[/q/i] ? eval(cmd) : system(cmd); nil }) }
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
