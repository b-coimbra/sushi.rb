# frozen_string_literal: true

module Symbols
  AND = '&&'
  OR = '||'
  PIPE = '|'
  ALL = constants.collect { |c| const_get(c) }
end

module Token
  Name = 'name'
  Parameter = 'parameters'
  Value = 'values'
end
