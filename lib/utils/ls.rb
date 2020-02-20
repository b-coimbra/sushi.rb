# typed: true
# frozen_string_literal: true

def ls(*args)
  dir, = *args

  dir = './' if dir.nil?

  if dir.start_with?('-')
    case dir
    when '-h'
      puts 'Shows all files'
    else
      # TODO: Throw custom error (defined in todo.org)
      print dir, ": Unknown flag!\n"
    end
  end

  Dir[dir + '*'].each do |f|
    puts f
  end
end

__END__
method: ls
description: lists all files
