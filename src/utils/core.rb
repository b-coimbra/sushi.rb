# -*- coding: utf-8 -*-
require_relative 'cmds'
require_relative 'aliases'
require_relative 'colors'
require_relative 'git'
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
        show_prompt_git? if blank?(input)
        autocompletion()
        input.to_s.strip.split('&&').map do |line|
          command, *args = line.split("\s")
          Thread.new {
            if !CMDS.has_key?(command.to_sym)
              if !(system line)
                approx = {}
                CMDS.keys.map(&:to_s).each { |w| approx.store(w, spellcheck(w, line).round(2).to_s) }
                minimum = approx.values.map(&:to_f).min
                if minimum < 0.6
                  approx.each { |k, v| puts "Did you misspell #{k.cyan}?" if v.to_f == minimum }
                else
                  handle_error "Command '#{line}' not found."
                end
              end
            else
              begin
                puts args.empty? ? CMDS[command.to_sym][0]::() : CMDS[command.to_sym][0]::(args)
              rescue ArgumentError, Errno::ENOENT, NameError, SyntaxError => e
                handle_error "#{command}: #{e}"
              rescue NoMethodError, TypeError => e
                handle_error "#{command}: #{CMDS[command.to_sym][1].values[1]}"
              end
            end unless blank?(line)
          }.join
          # changes prompt state to the current directory
          show_prompt_git?
          $buffer << line unless line == "<" || blank?(line)
        end
      end 
    end
  end
end

show_prompt_git?
