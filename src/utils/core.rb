require_relative 'cmds'
require_relative 'aliases'
require_relative 'colors'
require_relative 'git'
require_relative 'cd'
require_relative 'history'
require_relative 'autocomplete'

define_method(:is_windows) { !RUBY_PLATFORM[/linux|darwin|mac|solaris|bsd/im] }

define_method(:blank?) { |i| i.nil? || i.empty? || i[/^[\r|\t|\s]+$/m] }

define_method(:show_prompt_git?) { has_git? || $Prompt = $dir }

trace_var :$dir, proc { |loc| $dir = "~/#{loc}".magenta }

$> << "\nwelcome back#{', '+ENV['COMPUTERNAME'].capitalize if is_windows} (´･ω･`)\n"

class Core
  $buffer = []
  def main
    # current directory
    $dir ||= __dir__.split(File::SEPARATOR)[-1]*?/

    # handle Ctrl+C as blank input
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
              (!CMDS.has_key?(i.to_sym) ? (system i) : (puts CMDS[i.to_sym]::())) unless blank?(i)
            }.join
            # changing prompt state to the current directory
            show_prompt_git?
          end
          $buffer << i
        end
      end rescue NoMethodError abort "unknown command", main
    end
  end
end

$Prompt = $dir if !has_git?