# encoding: UTF-8
require 'fileutils'

### Built-in commands
CMDS = {
  :mv      => [
    -> (args) { file, loc = args; FileUtils.mv(file, loc); nil },
    :description => "moves file to another directory",
    :flags => "[FILE | DIR] [DIR]",
    :error => "Can't move file / invalid file name."
  ],
  :bar    => [
    -> (args) { bar(args*?\s) },
    :description => "hides or shows the statusbar",
    :flags => "[NIRCMD] [show|hide]",
    :error => "couldn't find nircmd.exe"
  ],
  :roll    => [
    -> { "Rolled the dice, and it came up as: #{rand(1..6).to_s.bg_blue}" },
    :description => "rolls the dice",
    :flags => "",
    :error => ''
  ],
  :todo   => [
    ->(args) { todo(args); nil },
    :description => "to-do list",
    :flags => "[add | remove | show | clear] <text>",
    :error => "Couldn't parse expression."
  ],
  :~      => [
    -> { rb_exec_mult() },
    :description => "evaluates multiline ruby expressions",
    :flags => "",
    :error => "Can't parse this expression.",
  ],
  :wget    => [
    -> (args) { wget(args*?\s); nil },
    :description => "fetches data from an URL",
    :flags => "[URL]",
    :error => "Couldn't connect to URL."
  ],
  :cal     => [
    -> { cal(2, 31) },
    :description => "shows calendar",
    :flags => "",
    :error => "Can't show date."
  ],
  :cat     => [
    -> (files) { cat(files); nil },
    :description => "display the content of any file",
    :flags => "[FILE1] | [FILE2] [>] [>>]",
    :error => "No such file in this directory."
  ],
  :<       => [
    -> { CMDS[$buffer[-1].to_sym][0]::() },
    :description => "executes the last command",
    :flags => "",
    :error => "The previous command is invalid."
  ],
  :rm      => [
    -> (file) { FileUtils.rm_r(file, :verbose => true) },
    :description => "removes file",
    :flags => "[DIR | FILE]",
    :error => "You don't have permission to delete this file."
  ],
  :touch   => [
    -> (*files) { FileUtils.touch(files) },
    :description => "creates file",
    :flags => "[FILE]",
    :error => "Can't create files in this directory / invalid file name."
  ],
  :mkdir   => [
    -> (folder = "new") { FileUtils.mkdir_p(folder) },
    :description => "creates folder",
    :flags => "[DIR]",
    :error => "Can't create folders in this directory / invalid folder name."
  ],
  :clear   => [
    -> { system is_windows ? 'cls' : 'clear'; nil },
    :description => "clears the shell",
    :flags => "",
    :error => ''
  ],
  :cd      => [
    -> (dir = ENV['HOME']) { Dir.chdir((dir.kind_of?(Array) ? dir*?\s : dir)); nil },
    :description => "changes directory",
    :flags => "[DIR]",
    :error => "Can't access this directory."
  ],
  :date    => [
    -> { Time.now.strftime('%d/%m/%Y') },
    :description => "shows current date",
    :flags => "",
    :error => ''
  ],
  :exit    => [
    -> { $> << "bye (￣▽￣)ノ"; exit 0 },
    :description => "exit shell",
    :flags => "",
    :error => ''
  ],
  :>       => [
    -> (*args) { rb_exec(args*?\s) },
    :description => "evaluates inline ruby/python expressions",
    :flags => "",
    :error => "Invalid syntax."
  ],
  :echo    => [
    -> (*str) { print str*?\s },
    :description => "prints text to shell",
    :flags => "[TEXT]",
    :error => "Invalid characters"
  ],
  :update  => [
    -> { `git pull origin master` },
    :description => "updates shell",
    :flags => "",
    :error => "Can't update the shell, is git installed?"
  ],
  :cmds    => [
    -> { CMDS.collect { |key, val| "%-20s %s %s" % [key.to_s.cyan, val[1].values[1].to_s.yellow,
      val[1].values[0]] }.sort_by(&:downcase) },
    :description => "shows all commands",
    :flags => "",
    :error => ''
  ],
  :colortest => [
    -> { colortest; nil },
    :description => "shows available colors",
    :flags => "",
    :error => ''
  ],
  :path    => [
    -> { ENV['Path'] },
    :description => "shows the environment variables",
    :flags => "",
    :error => ''
  ],
  :cowsay  => [
    -> (*phrase) { cowsay(phrase*?\s.to_s) },
    :description => "shows an ascii cow saying whatever. eg: cowsay hehe!",
    :flags => "[TEXT]",
    :error => ''
  ],
  :history => [
    -> { $buffer*?\n },
    :description => "shows history of commands",
    :flags => "",
    :error => ''
  ],
  :ls      => [
    -> (*flags) { ls(flags*?\s) },
    :description => "show all files on the current folder",
    :flags => "[-l | -la]",
    :error => ''
  ],
  :whoami  => [
    -> { ENV['COMPUTERNAME'].capitalize },
    :description => "display current user",
    :flags => "",
    :error => ''
  ],
  :pwd     => [
    -> { Dir.pwd },
    :description => "returns the current working directory",
    :flags => "",
    :error => ''
  ],
  :help    => [
    -> { help() },
    :description => "shows this help",
    :flags => "",
    :error => ''
  ],
  :screenfetch => [
    -> { screenfetch() },
    :description => "shows system information",
    :flags => "",
    :error => "Unable to retrieve system information"
  ]
}