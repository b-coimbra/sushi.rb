def colortest
  print "\n"
  names   = %w(black red green yellow blue pink cyan white default)
  fgcodes = (30..39).to_a - [38]
  reg     = "\e[%d;%dm%s\e[0m"
  bold    = "\e[1;%d;%dm%s\e[0m"
  row     = '          40       41       42       43       44       45       46       47       49'
  title   = 'COLORS AVAILABLE'

  puts title.rjust((row.length + title.length) / 2); puts row
  names.zip(fgcodes).each do |name, fg|
    s = fg
    puts "%7s "%name + "#{reg}  #{bold}   " * 9 % [fg,40,s,fg,40,s, fg,41,s,fg,41,s, fg,42,s,fg,42,s, fg,43,s,fg,43,s,  
      fg,44,s,fg,44,s, fg,45,s,fg,45,s, fg,46,s,fg,46,s, fg,47,s,fg,47,s, fg,49,s,fg,49,s]
  end
end