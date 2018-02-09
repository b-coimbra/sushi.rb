%w{ocra open-uri readline}.each do |lib|
  begin
    require lib
  rescue LoadError
    print "The gem '#{lib}' is missing, install it? [Y/n]: "
    confirm = gets.chomp
    if confirm[/[y]/im] || blank?(confirm)
      puts "Installing gem ..."
      system "gem install #{lib}"
      Gem.clear_paths
    else
      puts "Skipped dependency."
    end
  end
end
