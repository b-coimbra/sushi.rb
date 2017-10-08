def cowsay(sentence)
print "\n"
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