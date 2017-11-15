%w{ocra open-uri}.each do |lib|
  if !`gem list -i #{lib}`
    print "The gem '#{lib}' is missing, install it? [Y/n]: "
    confirm = gets.chomp
    if confirm[/[y]/im] || blank?(confirm)
      puts "Installing gem ..."
      system "gem install #{lib}"
      Gem.clear_paths
    else
      puts "Skipped dependency."
    end
    show_prompt_git?
  end
end