module Symbols
  AND = "&&"
  OR = "||"
  PIPE = "|"
  ALL = self.constants.collect { |c| self.const_get(c) }
end


