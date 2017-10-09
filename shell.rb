#!/usr/bin/env ruby
# encoding: utf-8
## One-file version of rb-shell, for testing
$: << File.join(__dir__, 'C:\\cygwin\\bin')

require 'fileutils'
require 'readline'

system "title rb-shell && cls"

class String
  { :reset          =>  0,
    :bold           =>  1,
    :dark           =>  2,
    :underline      =>  4,
    :blink          =>  5,
    :negative       =>  7,
    :black          => 30,
    :red            => 31,
    :green          => 32,
    :yellow         => 33,
    :blue           => 34,
    :cyan           => 36,
    :white          => 37,
    :magenta        => '1;35'
  }.each do |color, value|
    define_method color do
      "\e[#{value}m" + self + "\e[0m"
    end
  end
end

class String
  define_method(:format) { |*args| self.tr('{}', '%s') % args }
end

module Kernel
  alias_method :__init__, :initialize
  alias_method :import, :require
end

define_method(:input) { |str| print str; gets.to_s }
define_method(:len)   { |obj| obj.length }
define_method(:int)   { |num| num.to_i }
define_method(:str)   { |int| int.to_i }
define_method(:range) { |num| (0..num) }

define_method(:is_windows) { !RUBY_PLATFORM[/linux|darwin|mac|solaris|bsd/im] }

define_method(:connected?) { return (!!`ping 192.168.1.1`) rescue false }

define_method(:blank?) { |i| i.nil? || i.empty? || i[/^[\r|\t|\s]+$/m] }

define_method(:show_prompt_git?) { has_git? || $Prompt = $dir }

$> << "\nwelcome back#{', '+ENV['COMPUTERNAME'].capitalize if is_windows}!\n"

# prompt ansi codes
BEGIN { trace_var :$Prompt, proc { |dir| $> << "\n\e[36m┌──────── #{dir} \e[36m\e[0m\n\e[36m└────\e[0m " } }

# tracing directory changes
trace_var :$dir, proc { |loc| $dir = "~/#{loc}".magenta }

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
              puts "'#{line}' command does not exist.".red if !system line
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
    $> << "No folder named '#{dir}' in this directory!\n".red
    !has_git? && $Prompt = $dir 
  else
    CMDS[:cd]::(dir)
    has_git? || $Prompt = "#$dir".magenta
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
    #{CMDS.keys.sort_by(&:downcase)*(?\s"| ").yellow}
  }; exit 0
end

def cowsay(sentence)
print "\n"
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
  Dir['*'].map { |file| "│ %-1s %s".cyan % [ \
    ("\r├──" + " #{file}".magenta if File.directory?(file)), \
    ("+ \e[0m#{file}" if File.file?(file)) ] }
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
  require 'win32ole'
  (print 'Example: run google ruby programming'; return) if blank?(cmd)
  shell = WIN32OLE.new("Wscript.Shell")
  link, *keystrokes = cmd.split("\s")
  link = "www.#{link}.com"
  link =~ /www\.(.*)\.com/i
  title = $1.capitalize
  case RbConfig::CONFIG['host_os']
  when /mswin|mingw|cygwin/im
      system "start chrome #{link}"
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

def colortest
  print "\n"
  names   = %w(black red green yellow blue pink cyan white default)
  fgcodes = (30..39).to_a - [38]
  reg     = "\e[%d;%dm%s\e[0m"
  bold    = "\e[1;%d;%dm%s\e[0m"
  row     = '          40       41       42       43       44       45       46       47       49'
  title   = 'COLORS AVAILABLE'

  puts title.rjust((row.length + title.length) / 2); puts row

  names.zip(fgcodes).each do |name, fg|
    s = fg
    puts "%7s "%name + "#{reg}  #{bold}   " * 9 % [fg,40,s,fg,40,s, fg,41,s,fg,41,s, fg,42,s,fg,42,s, fg,43,s,fg,43,s,  
      fg,44,s,fg,44,s, fg,45,s,fg,45,s, fg,46,s,fg,46,s, fg,47,s,fg,47,s, fg,49,s,fg,49,s]
  end
end

def rb_exec(*cmds)
  cmds = cmds*?\s
  if !blank?(cmds)
    begin
      return eval cmds. \
        gsub(/try/im, 'begin'). \
        gsub(/finally/im, 'ensure'). \
        gsub(/\:(.*)/m, '; \1; end'). \
        gsub(/while True/im, 'loop do'). \
        gsub(/except\s(.*)/im, 'rescue \1'). \
        gsub(/import\s(\w+)/im, "require '\\1'"). \
        gsub(/for\s(.*)\sin\s(.*)\:\n\s(.*)/im, '\2.map { |\1| \3 }'). \
        gsub(/([if|else|elif|def|while|with|class|for]+\s.*?)\:/im, '\1;'). \
        gsub(/(if)\s__name__\s==\s'__main__'/im, '\1 __FILE__ == $0')
    rescue SyntaxError => e
      print e
    end
  else
    puts "example: > puts 'hello'.red"
  end
end

# Built-in commands
CMDS = {
  :<         =>-> { CMDS[$buffer[-1].to_sym]::() unless $buffer[-1].empty? },
  :mv        =>-> (*args) { file, loc = args; FileUtils.mv(file, loc) },
  :cmds      =>-> { CMDS.keys.sort_by(&:downcase)*(?\s"| ").yellow },
  :rm        =>-> (file) { FileUtils.rm_r(file, :verbose => true) },
  :calc      =>-> (*expression) { calc(expression.join("\s")) },
  :mkdir     =>-> (folder = "new") { FileUtils.mkdir(folder) },
  :clear     =>-> { system is_windows ? 'cls' : 'clear'; nil },
  :cd        =>-> (dir = ENV['HOME']) { Dir.chdir dir; nil },
  :cowsay    =>-> (*phrase) { cowsay(phrase.join("\s")) },
  :touch     =>-> (*files) { FileUtils.touch(files) },
  :date      =>-> { Time.now.strftime('%d/%m/%Y') },
  :exit      =>-> { $> << "bye (￣▽￣)ノ"; exit 0 },
  :>         =>-> (*args) { rb_exec(args); nil },
  :update    =>-> { `git pull origin master` },
  :run       =>-> (*args) { run(args*?\s) },
  :echo      =>-> (*str) { print str*?\s },
  :colortest =>-> { colortest; nil },
  :path      =>-> { ENV['Path'] },
  :history   =>-> { $buffer*?\n },
  :pwd       =>-> { Dir.pwd },
  :ls        =>-> { ls }
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
'att' .alias 'sudo apt-get update'
# 'off' .alias 'shutdown -s -f -t 0'

case $*[0]
when /(\-+|h)+/i then help # --help flag
else 
  $Prompt = $dir if !has_git?
  main if $0 == __FILE__
end

# check for exception when terminating
at_exit { abort $! ? "Uh.. you broke the shell ¯\\_(ツ)_/¯" : "bye (￣▽￣)ノ" }
