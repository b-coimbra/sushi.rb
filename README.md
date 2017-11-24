# sushi.rb

![sushi.rb](https://s1.postimg.org/58vzwgp8zz/rb-shell.png)

Custom prompt with unix features written in Ruby.

Inspired by [shirt](https://github.com/jstorimer/shirt)

### Usage

- Clone this repo, or download it into a directory of your choice.
- Using the [rake gem](https://github.com/ruby/rake), type `$ rake run` to start the shell
  - Or either run `$ ruby src/sushi.rb` or `run.cmd`
- Type `cmds` or `help` to get a full list of the commands and aliases.
- To integrate with Cmder (or ConEmu), open the settings and go to `Startup > Tasks` and paste the location to `C:\<path-to-executable>\shell.exe`

### Dependencies
- There are no dependencies for the binaries, except having a font that supports unicode characters if you care how the prompt looks.

### Building

- Install the [OCRA](https://github.com/larsch/ocra) gem with `$ gem install ocra`
- Type `$ rake build` in the root directory to build an executable file.
- The executable file can be found in the `bin` folder.

### To do
- [x] Add command-line extensions (import utilities from cygwin and the native shell)
- [ ] Integrate with Powershell
- [x] Command stacking (eg `cd documents && ls`)
- [x] Directory and command autocompletion with TAB (see [bug](https://github.com/c0imbra/sushi.rb/issues/1))
- [x] Command history with Up Arrow
- [x] Spellchecking
- [x] Pipe operator
- [x] Shell scripting with interactive ruby / python

### Preview

![preview](https://i.imgur.com/iu0u7wm.gif)

### Contributing
Bug fixes and pull requests are welcome.
