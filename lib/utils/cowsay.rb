# typed: ignore
# frozen_string_literal: true

def cowsay(*args)
  sentence, = args

  print %{
   _#{'_' * sentence.length}_
  < #{sentence} >
   -#{'-' * sentence.length}-
        \\   ^__^
         \\  (oo)\\_______
            (__)\\       )/\\
                ||----w |
                ||     ||
  }
end

__END__
method: cowsay
description: ascii cow say funni thing
