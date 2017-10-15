# WARN: this script slows down the shell initialization
# %w{ocra}.each do |lib|
#   if !`gem list -i #{lib}`
#     print "The gem '#{lib}' is missing, install it? [Y/n]: "
#     confirm = gets.chomp
#     if confirm[/[y]/im] || blank?(confirm)
#       puts "Installing gem ..."
#       system "gem install #{lib}"
#       Gem.clear_paths
#     else
#       puts "Okay."
#     end
#     show_prompt_git?
#   end
# end