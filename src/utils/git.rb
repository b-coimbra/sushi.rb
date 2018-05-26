require_relative 'core'

def powerline_git(str, symbol="\u{e0a0}", color="41")
  "\e[#{color}m\e[30m\e[0m\e[0m\e[#{color}m\s#{symbol}\s#{str}\e[0m#$dir"
end

# checks if current directory is a git repo
def has_git?
  $dir = Dir.pwd.split(File::SEPARATOR)[-1..-1]*?/

  if test ?e, '.git'
    if `git rev-parse --git-dir` =~ /^\.git$/im
      $Prompt = powerline_git(`git rev-parse --abbrev-ref HEAD`.strip + ' ')
    end
  else
    $Prompt = powerline_git('', "\u{e0a2}")
  end
end
