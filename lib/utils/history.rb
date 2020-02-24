# typed: true
# frozen_string_literal: true

require_relative '../history'

def history(*args)
  flag, value = *args
  history = History.new

  # check if it's an actual flag
  case flag
  when '-c'
    history.clear
  when '-n'
    puts history.get value.to_i
  else
    puts history.get
  end
end

__END__
method: history
description: history operations
