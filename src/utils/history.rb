def history
  input = Readline.readline('', true)
  # read a line and append to history
  Readline::HISTORY.pop if input =~ /^\s*$/ or Readline::HISTORY.to_a[-2] == input
  input
end