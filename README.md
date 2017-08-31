# rb-shell

Custom prompt with unix features for Cmder (or ConEmu) written in Ruby.

### Usage

- Clone this repo, or download it into a directory of your choice.
- With Cmder open, open the settings and set it at `Startup > Tasks` and paste the location to `C:\<your-location>\shell.exe`
- Type `cmds` to get a full list of the commands and aliases.
- Use `<` to execute the previous command, instead of the default "up arrow".

### Building executable

- Install the [OCRA](https://github.com/larsch/ocra) gem with `gem install ocra`
- Type `ocra shell.rb` to build it.

### To do
- [ ] Add command-line extensions (or import them from cygwin)
- [ ] Command stacking (eg `cd documents && ls` 

### Preview

![preview](https://i.imgur.com/T933Vu1.png)
