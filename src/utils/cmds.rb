# -*- coding: utf-8 -*-

### Built-in commands
CMDS = {
  :mv      => [
    -> (args) { file, loc = args.split("\s"); FileUtils.mv(file, loc) },
    :description => "moves file to another directory"
  ],
  :<       => [
    -> { CMDS[$buffer[-1].to_sym]::() unless $buffer[-1].empty? },
    :description => "executes the last command"
  ],
  :rm      => [
    -> (file) { FileUtils.rm_r(file, :verbose => true) },
    :description => "removes file"
  ],
  :touch   => [
    -> (*files) { FileUtils.touch(files.split("\s")) },
    :description => "creates file"
  ],
  :mkdir   => [
    -> (folder = "new") { FileUtils.mkdir(folder) },
    :description => "creates folder"
  ],
  :clear   => [
    -> { system is_windows ? 'cls' : 'clear'; nil },
    :description => "clears the buffer"
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
  :update  => [
    -> { `git pull origin master` },
    :description => "updates shell"
  ],
  :cmds    => [
    -> { CMDS.keys*(?\s"\s") },
    :description => "shows all commands"
  ],
  :path    => [
    -> { ENV['Path'] },
    :description => "environment variables"
  ],
  :cowsay  => [
    -> (*phrase) { cowsay(phrase.join("\s").to_s) },
    :description => "cowsay command"
  ],
  :history => [
    -> { $buffer*?\n },
    :description => "command history"
  ],
  :ls      => [
    -> { Dir['*'] },
    :description => "show all files on the current folder"
  ],
  :pwd     => [
    -> { Dir.pwd },
    :desciption => "current working directory"
  ]
}
