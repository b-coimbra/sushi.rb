# encoding: utf-8
class String
  { :reset          =>  0,
    :bold           =>  1,
    :dark           =>  2,
    :underline      =>  4,
    :blink          =>  5,
    :negative       =>  7,
    :black          => 30,
    :green          => 32,
    :yellow         => 33,
    :blue           => 34,
    :cyan           => 36,
    :white          => 37,
    :red            => '1;31',
    :magenta        => '1;35',
    :bg_black       => 40,
    :bg_red         => 41,
    :bg_green       => 42,
    :bg_brown       => 43,
    :bg_blue        => 44,
    :bg_magenta     => 45,
    :bg_cyan        => 46,
    :bg_gray        => 47
  }.each do |color, value|
    define_method color do
      "\e[#{value}m" + self + "\e[0m"
    end
  end
end

