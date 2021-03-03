# typed: true
# frozen_string_literal: true

# Structure of a command's argument
class Argument < T::Enum
  enums do
    Parameter = new
    Value     = new
  end
end
