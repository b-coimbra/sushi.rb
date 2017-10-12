require 'fileutils'
# -*- coding: utf-8 -*-

### Built-in commands
CMDS = {
  :mv      => [
    -> (args) { file, loc = args; FileUtils.mv(file, loc); nil },
    :description => "moves file to another directory"
  ],
  :<       => [
    -> { CMDS[$buffer[-1].to_sym][0]::() unless $buffer[-1].empty? },
    :description => "executes the last command"
  ],
  :rm      => [
    -> (file) { FileUtils.rm_r(file, :verbose => true) },
    :description => "removes file"
  ],
  :touch   => [
    -> (*files) { FileUtils.touch(files) },
    :description => "creates file"
  ],
  :mkdir   => [
    -> (folder = "new") { FileUtils.mkdir(folder) },
    :description => "creates folder"
  ],
  :clear   => [
    -> { system is_windows ? 'cls' : 'clear'; nil },
    :description => "clears the shell"
  ],
  :cd      => [
    -> (dir = ENV['HOME']) { Dir.chdir dir; nil },
    :description => "changes directory"
  ],
  :date    => [
    -> { Time.now.strftime('%d/%m/%Y') },
    :description => "shows current date"
  ],
  :exit    => [
    -> { $> << "bye (￣▽￣)ノ"; exit 0 },
    :description => "exit shell"
  ],
  :>       => [
    -> (*args) { rb_exec(args*?\s) },
    :description => "evaluates ruby/python expressions"
  ],
  :echo    => [
    -> (*str) { print str.join("\s") },
    :description => "prints text to shell"
  ],
  :update  => [
    -> { `git pull origin master` },
    :description => "updates shell"
  ],
  :run     => [
    -> (*args) { run(args*?\s) },
    :description => "opens website through active browser, then types something"
  ],
  :cmds    => [
    -> { CMDS.collect { |key, val| "%-20s %s" % [key.to_s.cyan, val[1].to_s.gsub(/\{\:description\=\>|\"|\}/m,'')] }.sort_by(&:downcase) },
    :description => "shows all commands"
  ],
  :colortest => [
    -> { colortest; nil },
    :description => "shows available colors"
  ],
  :path    => [
    -> { ENV['Path'] },
    :description => "shows the environment variables"
  ],
  :cowsay  => [
    -> (*phrase) { cowsay(phrase.join("\s").to_s) },
    :description => "shows an ascii cow saying whatever. eg: cowsay hehe!"
  ],
  :history => [
    -> { $buffer*?\n },
    :description => "shows history of commands"
  ],
  :ls      => [
    -> { ls },
    :description => "show all files on the current folder"
  ],
  :pwd     => [
    -> { Dir.pwd },
    :description => "returns the current working directory"
  ],
  :help    => [
    -> { help },
    :description => "shows this help"
  ],
  :screenfetch => [
    -> { screenfetch },
    :description => "shows system information"
  ]
}
