# frozen_string_literal: true

require_relative 'symbols'
require_relative 'error'
require_relative 'ext/string'

# TODO: split into multiple classes (syntax/ folder: lexer and parser),

# Parses the config file
class Parser
  include Symbols
  include Token

  def initialize
    @loader = Loader.new
  end

  def parse(chain)
    chain    = chain.split(Symbols::AND).map(&:strip)
    commands = []
    tokens   = []

    chain.each do |command|
      stream = command.split("\s")

      stream.each do |value|

        if command?(value)
          tokens.push(Token::Parameter) if tokens.include?(Token::Name) # when a command is passed as parameter: eg. help ls
          tokens.push(Token::Name)      unless tokens.include?(Token::Name)
        end

        tokens.push(Token::Parameter) if parameter?(value)
      end

      # when a command has a parameter flag, it also holds it's value
      tokens.push(Token::Value) if tokens.include?(Token::Parameter)

      commands.push(Hash[tokens.map(&:to_sym).zip(stream)])
    end

    raise Error, ErrorType::ParseError if commands.empty?

    commands
  end

  def tokenize
    Symbols::ALL.each do |sym|
      if command.is_a? Array
        command.each_with_index do |c, i|
          command[i] = separate(command[i], sym) if sym? command[i], sym
        end
      else
        command = separate(command, sym) if sym? command, sym
      end
    end
  end

  def sym? expr, sym
    p expr + sym
    expr.match sym.to_regex
  end

  def command? sym
    @loader.in_env? sym
  end

  def parameter? sym
    true if sym.start_with?('-')
  end

  def separate expr, sym
    expr.split sym.to_regex
  end
end
