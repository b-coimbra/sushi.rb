# frozen_string_literal: true

module Symbols
  AND = '&&'
  OR = '||'
  PIPE = '|'
  ALL = constants.collect { |c| const_get(c) }
end

# Token structure
module Token
  NAME = 'name'
  PARAMETER = 'parameters'
  VALUE = 'values'

  def self.param?(token)
    token.start_with?('-')
  end

  def self.name?(tokens)
    tokens.include?(Token::NAME)
  end

  def self.value?(tokens)
    tokens.include?(Token::VALUE)
  end
end
