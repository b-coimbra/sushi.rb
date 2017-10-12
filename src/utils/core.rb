# -*- coding: utf-8 -*-
require_relative 'cmds'
require_relative 'aliases'
require_relative 'colors'
require_relative 'git'
require_relative 'cd'
require_relative 'history'
require_relative 'autocomplete'
require_relative 'methods'

# traces current directory
trace_var :$dir, proc { |loc| $dir = "~/#{loc}".magenta }

$> << %{
  .     '     ,
    _________
 _ /_|_____|_\\ _
   '. \\   / .' 
     '.\\ /.'
       '.'\n}.red

class Core
  $buffer = []
  def main
    # current directory
    $dir ||= __dir__.split(File::SEPARATOR)[-1]*?/

    # handle Ctrl+C as blank input
    trap("SIGINT") { show_prompt_git? }

    catch :ctrl_c do
      while input = history()
        # handling blank inputs
        show_prompt_git? if blank?(input)
        # trigger autocompletion
        autocompletion()
        input.to_s.strip.split('&&').map do |line|
          # when a directory change is requested
          if line =~ /cd(?<dir>(\s(.*)+))/im
            change_dir($~[:dir].to_s.strip)
          else
            command, *args = line.split("\s")
            # trigger command through native shell if not defined as a built-in
            Thread.new {
              if !CMDS.has_key?(command.to_sym)
                handle_error "Command '#{line}' not found." if !system line
              else
                begin
                  puts args.empty? ? CMDS[command.to_sym][0]::() : CMDS[command.to_sym][0]::(args)
                rescue ArgumentError
                  handle_error "#{command}: No parameters found."
                rescue NoMethodError, Errno::ENOENT, TypeError => e
                  # fetch error message from current command
                  handle_error "#{command}: " + CMDS[command.to_sym][1].values[1]
                end
              end unless blank?(line)
            }.join
            # changes prompt state to the current directory
            show_prompt_git?
          end
          $buffer << line
        end
      end 
    end
  end
end

show_prompt_git?
