# built-in commands
CMDS = {
  :mv      =>-> (args) { file, loc = args.split("\s"); FileUtils.mv(file, loc) },
  :<       =>-> { CMDS[$buffer[-1].to_sym]::() unless $buffer[-1].empty? },
  :rm      =>-> (file) { FileUtils.rm_r(file, :verbose => true) },
  :touch   =>-> (*files) { FileUtils.touch(files.split("\s")) },
  :mkdir   =>-> (folder = "new") { FileUtils.mkdir(folder) },
  :clear   =>-> { system is_windows ? 'cls' : 'clear'; nil },
  :cd      =>-> (dir = ENV['HOME']) { Dir.chdir dir; nil },
  :date    =>-> { Time.now.strftime('%d/%m/%Y') },
  :exit    =>-> { $> << "bye (￣▽￣)ノ"; exit 0 },
  :update  =>-> { `git pull origin master` },
  :cmds    =>-> { CMDS.keys*(?\s"\s") },
  :path    =>-> { ENV['Path'] },
  :history =>-> { $buffer*?\n },
  :ls      =>-> { Dir['*'] },
  :pwd     =>-> { Dir.pwd }
}