#!/usr/bin/env ruby
# encoding: UTF-8

require 'readline'

system 'title sushi && cls'

# loads all packages
Dir[File.join(__dir__, %w[utils], '*.rb')].map(&method(:require))

BEGIN {
  $user = ENV['USER']
  $time = Time.now.strftime("%H:%M").to_s

  trace_var :$Prompt, proc { |dir| $> << \
    # PROMPT
    "\n\e[36m┌──\e[0m\s#{dir}\n\e[36m└────\e[0m\s"
  }
}

## alias / command / description
'c'   .alias 'cls', 'clears buffer'
'q'   .alias 'exit', 'quits shell'
's'   .alias 'subl .', 'sublime'
'att' .alias 'git pull', 'update'
'e'   .alias 'emacs -nw', 'emacs'
'o'   .alias 'explorer .', 'opens current directory'

# execute approximate misspelled words
$exec_approx = false

case ARGV[0]
when /(\-+h)+/i then help # --help flag
else
  exit if defined? Ocra
  # initialize the shell
  Core.main if __FILE__ == $0
end

# handle errors when exiting
at_exit { abort $! ? "Uh.. you broke the shell ¯\\_(ツ)_/¯" : "bye (￣▽￣)ノ" }

fail SystemStackError, 'You found a bug, please open an issue at https://github.com/c0imbra/sushi.rb/issues/'
