class String
  { :reset          =>  0,
    :bold           =>  1,
    :dark           =>  2,
    :underline      =>  4,
    :blink          =>  5,
    :negative       =>  7,
    :black          => 30,
    :red            => '1;31',
    :green          => 32,
    :yellow         => 33,
    :blue           => 34,
    :cyan           => 36,
    :white          => 37,
    :magenta        => '1;35'
  }.each do |color, value|
    define_method color do
      "\e[#{value}m" + self + "\e[0m"
    end
  end
end