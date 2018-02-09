# -*- coding: utf-8 -*-
# TODO: refactoring
require_relative 'cmds'
require_relative 'aliases'
require_relative 'colors'
require_relative 'git'
require_relative 'history'
require_relative 'autocomplete'
require_relative 'methods'
require_relative 'pipeline'

def powerline(str)
  "\e[46m\e[31m\e[0m\e[0m\e[46m\s#{str}\s\e[0m\e[36m\e[0m"
end

# traces current directory
trace_var :$dir, proc { |loc| $dir = (ENV['HOME'] == Dir.pwd ? (powerline('~')) : (powerline('~/'+loc))) }

class Core
  $buffer = []
  def self.main
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
          command.downcase!
          # apply pipe into the command
          pipe_command = ->(flag=nil, pipes) {
            pipes.each { |pipe| puts pipable("#{flag.nil? ? CMDS[command.to_sym][0]::()
            : CMDS[command.to_sym][0]::(flag.strip)}") | eval(pipe) }
          }

          Thread.new {
            # tries to execute the command through the native shell when not recognized
            if !CMDS.has_key?(command.to_sym)
              if !(system line)
                # attempt to find the most similar command based off the mispelled word
                approx = {}
                CMDS.keys.map(&:to_s).each { |word| approx.store(word, spellcheck(word, line).round(2).to_s) }
                minimum = approx.values.map(&:to_f).min

                if minimum < 0.6
                  approx.each do |cmd, val|
                    if val.to_f == minimum
                      if $exec_approx
                        CMDS[cmd.to_sym][0]::()
                      else
                        puts "Did you misspell #{command.cyan}?"
                      end
                    end
                  end
                else
                  handle_error "#{line}: command not found."
                end
              end
            else
              begin
                # decides whether or not the command requires arguments, then execute it
                if args.empty?
                  puts CMDS[command.to_sym][0]::()
                # parsing pipes
                elsif args*?\s =~ /\|.(.*)/m
                  flag = $`
                  pipes = []
                  args.join("\s").gsub(flag, '').split.delete_if { |x| x == "|" }.each { |pipe| pipes << (':' + pipe) }
                  (flag !~ /^|/ || CMDS[command.to_sym][0].arity <= -1) ? pipe_command.(flag, pipes) : pipe_command.(pipes)
                else
                  puts CMDS[command.to_sym][0]::(args)
                end
              rescue ArgumentError, Errno::ENOENT, Errno::EINVAL, SyntaxError, IOError, LoadError, StandardError => e
                # trigger common error messages from the ruby interpreter when an exception happens
                handle_error "#{command}: #{e}"
              rescue NoMethodError, TypeError => e
                # fetches default error messages from the command
                handle_error "#{command}: #{CMDS[command.to_sym][1].values[1]}"
              end
            end unless blank?(line)
          }.join
          # changes prompt state to the current directory
          show_prompt_git?
          # feed buffer for history usage
          $buffer << line unless line == "<" || blank?(line)
        end
      end rescue next
    end
  end
end

show_prompt_git?
