def cowsay(sentence)
_ = <<COWSAY
 _#{'_'*sentence.length}_
< #{sentence} >
 -#{'-'*sentence.length}-
      \\   ^__^
       \\  (oo)\\_______
          (__)\\       )/\\
              ||----w |
              ||     ||
COWSAY
end