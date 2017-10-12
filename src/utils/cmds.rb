# encoding: UTF-8
require 'fileutils'

### Built-in commands
CMDS = {
  :mv      => [
    -> (args) { file, loc = args; FileUtils.mv(file, loc); nil },
    :description => "moves file to another directory",
    :error => "Can't move file / invalid file name."
  ],
  :cat     => [
    -> (files) { cat(files) },
    :description => "display text files",
    :error => "No such file in this directory."
  ],
  :<       => [
    -> { CMDS[$buffer[-1].to_sym][0]::() unless $buffer[-1].empty? },
    :description => "executes the last command",
    :error => "The previous command is invalid."
  ],
  :rm      => [
    -> (file) { FileUtils.rm_r(file, :verbose => true) },
    :description => "removes file",
    :error => "You don't have permission to delete this file."
  ],
  :touch   => [
    -> (*files) { FileUtils.touch(files) },
    :description => "creates file",
    :error => "Can't create files in this directory / invalid file name."
  ],
  :mkdir   => [
    -> (folder = "new") { FileUtils.mkdir(folder) },
    :description => "creates folder",
    :error => "Can't create folders in this directory / invalid folder name."
  ],
  :clear   => [
    -> { system is_windows ? 'cls' : 'clear'; nil },
    :description => "clears the shell",
    :error => ''
  ],
  :cd      => [
    -> (dir = ENV['HOME']) { Dir.chdir dir; nil },
    :description => "changes directory",
    :error => "Can't access this directory."
  ],
  :date    => [
    -> { Time.now.strftime('%d/%m/%Y') },
    :description => "shows current date",
    :error => ''
  ],
  :exit    => [
    -> { $> << "bye (￣▽￣)ノ"; exit 0 },
    :description => "exit shell",
    :error => ''
  ],
  :>       => [
    -> (*args) { rb_exec(args*?\s) },
    :description => "evaluates ruby/python expressions",
    :error => "Invalid syntax."
  ],
  :echo    => [
    -> (*str) { print str.join("\s") },
    :description => "prints text to shell",
    :error => "Invalid characters"
  ],
  :update  => [
    -> { `git pull origin master` },
    :description => "updates shell",
    :error => "Can't update the shell, is git installed?"
  ],
  :run     => [
    -> (*args) { run(args*?\s) },
    :description => "opens website through active browser, then types something",
    :error => "Couldn't find a working browser"
  ],
  :cmds    => [
    -> { CMDS.collect { |key, val| "%-20s %s" % [key.to_s.cyan, val[1].values[0]] }.sort_by(&:downcase) },
    :description => "shows all commands",
    :error => ''
  ],
  :colortest => [
    -> { colortest; nil },
    :description => "shows available colors",
    :error => ''
  ],
  :path    => [
    -> { ENV['Path'] },
    :description => "shows the environment variables",
    :error => ''
  ],
  :cowsay  => [
    -> (*phrase) { cowsay(phrase.join("\s").to_s) },
    :description => "shows an ascii cow saying whatever. eg: cowsay hehe!",
    :error => ''
  ],
  :history => [
    -> { $buffer*?\n },
    :description => "shows history of commands",
    :error => ''
  ],
  :ls      => [
    -> { ls },
    :description => "show all files on the current folder",
    :error => ''
  ],
  :whoami  => [
    -> { ENV['COMPUTERNAME'].capitalize },
    :description => "display current user",
    :error => ''
  ],
  :pwd     => [
    -> { Dir.pwd },
    :description => "returns the current working directory",
    :error => ''
  ],
  :help    => [
    -> { help },
    :description => "shows this help",
    :error => ''
  ],
  :screenfetch => [
    -> { screenfetch },
    :description => "shows system information",
    :error => "Unable to retrieve system information"
  ]
}
