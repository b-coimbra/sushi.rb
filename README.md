# rb-shell

Custom prompt with unix features written in Ruby.

Inspired by [shirt](https://github.com/jstorimer/shirt)

### Usage

- Clone this repo, or download it into a directory of your choice.
- Open the `bin` folder and run the `shell.exe`, or go into `src/` and run `$ ruby main.rb`
- Type `cmds` to get a full list of the commands and aliases.
- To integrate with Cmder (or ConEmu), open the settings and go to `Startup > Tasks` and paste the location to `C:\<your-location>\shell.exe`

### Building

- Install the [OCRA](https://github.com/larsch/ocra) gem with `$ gem install ocra`
- Type `$ ocra src --output shell.exe` in the root directory to build it.

### To do
- [x] Add command-line extensions (or import them from cygwin)
- [x] Command stacking (eg `cd documents && ls`)
- [ ] Package installer (maybe through [Chocolatey](https://chocolatey.org/))
- [x] Directory and command autocompletion with TAB
- [x] Command history with Up Arrow 

### Preview

![preview](https://i.imgur.com/T933Vu1.png)

### Contributing
Bug fixes and pull requests are welcome.
