def cowsay sentence
  print %{
   _#{'_'*sentence.length}_
  < #{sentence} >
   -#{'-'*sentence.length}-
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
