#!/usr/bin/env ruby
# encoding: UTF-8
require 'readline'
require 'fileutils'

system 'title rb-shell'

# loads all packages
Dir[File.join(__dir__, %w[utils], '*.rb')].map(&method(:require))

# PROMPT
BEGIN { trace_var :$Prompt, proc { |dir| $> << "\n\e[33m┌─────┄┄ #{dir} \n\e[33m└──┄\e[0m " } }

case ARGV[0]
when /(\-+|h)+/i then help # --help flag
else
  # initialize the shell
  Core::new.main if __FILE__ == $0
end

# Handle errors when exiting
at_exit { abort $! ? "Uh.. you broke the shell ¯\\_(ツ)_/¯" : "bye (￣▽￣)ノ" }

fail SystemStackError, 'You found a bug, please open an issue at https://github.com/c0imbra/rb-shell/issues/'
