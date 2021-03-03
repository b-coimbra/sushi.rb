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
  SYS = 'system_command'

  def self.param?(token)
    token.start_with?('-')
  end

  def self.name?(tokens)
    !tokens.nil? && tokens.include?(Token::NAME)
  end

  def self.value?(tokens)
    !tokens.nil? && tokens.include?(Token::VALUE)
  end

  def self.sys?(tokens)
    !tokens.nil? && tokens.include?(Token::SYS)
  end

  def self.previous(tokens, index)
    tokens[index - 1]
  end
end
