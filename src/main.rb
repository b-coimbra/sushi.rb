#!/usr/bin/env ruby
# encoding: UTF-8
require 'readline'

system 'title sushi && cls'

# loads all packages
Dir[File.join(__dir__, %w[utils], '*.rb')].map(&method(:require))

# PROMPT
BEGIN { trace_var :$Prompt, proc { |dir| $> << "\n\e[36m┌──────── #{dir} \e[36m\e[0m\n\e[36m└────\e[0m " } }

###  Command aliases
##   alias / command / description
'c'   .alias 'cls', 'clears buffer'
'q'   .alias 'exit', 'quits shell'
's'   .alias 'subl .', 'sublime'
'att' .alias 'git pull', 'update'
'e'   .alias 'emacs -nw', 'emacs'
'o'   .alias 'explorer .', 'opens current directory'
# 'off' .alias 'shutdown -s -f -t 0', 'shutdown'

case ARGV[0]
when /(\-+h)+/i then help # --help flag
else
  # initialize the shell
  Core::new.main if __FILE__ == $0
end

# Handle errors when exiting
at_exit { abort $! ? "Uh.. you broke the shell ¯\\_(ツ)_/¯" : "bye (￣▽￣)ノ" }

fail SystemStackError, 'You found a bug, please open an issue at https://github.com/c0imbra/rb-shell/issues/'