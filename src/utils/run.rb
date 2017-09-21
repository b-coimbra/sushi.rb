require 'win32ole'

## opens a website through the active browser, then types something in it
def run(cmd)
  (print 'Example: run google ruby programming'; return) if !blank?(cmd)
  shell = WIN32OLE.new("Wscript.Shell")
  link, *keystrokes = cmd.split("\s")
  link = "www.#{link}.com"
  link =~ /www\.(.*)\.com/i
  title = $1.capitalize
  case RbConfig::CONFIG['host_os']
  when /mswin|mingw|cygwin/im
      system "start #{link}"
  when /darwin/im
      system "open #{link}"
  when /linux|bsd/im
      system "xdg-open #{link}"
  end
  sleep 4
  (shell.Run(title); sleep 0.5) while !shell.AppActivate(title)
  shell.SendKeys(keystrokes*?\s + "{ENTER}")
  print "Sent: \e[31m#{keystrokes*?\s}\e[0m to: #{link}"
end