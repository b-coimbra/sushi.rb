# shell.rb

![shell.rb](https://s1.postimg.org/58vzwgp8zz/rb-shell.png)

Custom prompt with unix features written in Ruby.

Inspired by [shirt](https://github.com/jstorimer/shirt)

### Usage

- Clone this repo, or download it into a directory of your choice.
- Using the [rake gem](https://github.com/ruby/rake), type `$ rake run` to start the shell
  - Or go into `src/` and run `$ ruby main.rb`
- Type `cmds` to get a full list of the commands and aliases.
- To integrate with Cmder (or ConEmu), open the settings and go to `Startup > Tasks` and paste the location to `C:\<path-to-executable>\shell.exe`

### Building

- Install the [OCRA](https://github.com/larsch/ocra) gem with `$ gem install ocra`
- Type `$ rake build` in the root directory to build an executable file.
- The executable file can be found in the `bin` folder.

### To do
- [x] Add command-line extensions (or import them from cygwin)
- [x] Command stacking (eg `cd documents && ls`)
- [ ] Package installer (maybe through [Chocolatey](https://chocolatey.org/))
- [x] Directory and command autocompletion with TAB
- [x] Command history with Up Arrow
- [x] shell scripting with interactive ruby / python

### Preview

![preview](https://i.imgur.com/8oA0Cna.gif)

### Contributing
Bug fixes and pull requests are welcome.
