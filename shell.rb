#!/usr/bin/env ruby
# encoding: UTF-8

system "title #{$0} - #{Dir.pwd}"

BEGIN { trace_var :$Prompt, proc { |c| $> << "\n\e[0;\n\e[33m┌─────┄┄ #{c} \e[33m\e[0m#{Time.now.strftime('%H:%M')}\n\e[33m└──┄\e[0m " }; $Prompt = '' }

def main
  trap("SIGINT") { throw :ctrl_c }

  catch :ctrl_c do
    $<.map do |input|
      i = input.to_s.strip

      if i =~ /cd(?<dir>(\s(.*)+))/im
        dir = $~[:dir].to_s.strip

        if !test(?e, dir)
          $> << "No directory named #{dir}\n"

          $Prompt = ''
        else
          CMDS["cd"]::(dir)

          $Prompt = "\e[1;35m~/#{dir}\e[0m"
        end
      else
        !CMDS.has_key?(i) ? (system i) : (puts CMDS[i]::()) unless (i.nil? || i.empty? || i[/\r/m]) == true

        $Prompt = "\e[1;35m~/#{Dir.pwd.split('/')[-1..-1]*?/}\e[0m"
      end
    end rescue NoMethodError abort "unknown command"
  end
end

def help
  print %{
    Usage: ruby shell.rb (or run the executable)

    Type any command into the terminal, that's it!
  }; exit 0
end

CMDS = {
  "cd"   => -> (dir = __dir__) { Dir.chdir dir },
  "date" => -> { Time.now.strftime('%d/%m/%Y') },
  "cls"  => -> { system 'cls' },
  "cmds" => -> { CMDS.keys*?| },
  "path" => -> { ENV['Path'] },
  "ls"   => -> { Dir["./*"] },
  "pwd"  => -> { Dir.pwd },
  "exit" => -> { exit 0 }
}

case ARGV[0]
when /(\-+|h)+/i then help
else main if $0 == __FILE__
end

at_exit { abort $! ? "Uh.. you broke the shell ¯\\_(ツ)_/¯" : "bye (￣▽￣)ノ" }