def ls *args
  dir, _ = *args

  Dir[dir + '*'].each do |f|
    puts f
  end
end

__END__
method: ls
description: lists all files
