# typed: false
# frozen_string_literal: true

def cat(*args)
  file, = *args

  return if file.empty?

  File.open(file, 'r').each_line { |line| puts line }
end

__END__
method: cat
description: prints a file
