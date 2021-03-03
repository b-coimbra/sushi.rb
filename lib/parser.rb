# typed: true
# frozen_string_literal: true

require_relative 'symbols'
require_relative 'error'
require_relative 'ext/string'

# TODO: split into multiple classes (syntax/ folder: lexer and parser),

# Parses the config file
class Parser
  extend T::Sig

  include Symbols
  include Token

  CommandType = T.type_alias { T::Hash[Symbol, T.nilable(String)] }
  TokenStream = T.type_alias { T::Array[String] }

  attr_reader :commands

  def initialize
    @loader = Loader.new
    @commands = []
  end

  # mv to lexer
  sig { params(chain: String).returns(T::Array[CommandType]) }
  def parse(chain)
    chop(chain).each do |command|
      stream = command.split("\s")
      tokens = tokenize(stream)

      @commands.push(to_command(tokens, stream))

      # puts @commands
    end

    throw(ErrorType::ParseError) if @commands.empty?

    @commands
  end

  # mv to lexer.rb
  sig { params(stream: TokenStream).returns(T::Array[String]) }
  def tokenize(stream)
    tokens = []

    stream.each.with_index do |value, i|
      previous_token = Token.previous(tokens, i)

      tokens.push(Token::SYS)       unless command?(value) || Token.sys?(previous_token) || Token.value?(value) || Token.param?(value)
      tokens.push(Token::VALUE)     if Token.sys?(previous_token)
      tokens.push(Token::NAME)      unless Token.name?(tokens) || Token.sys?(tokens)
      tokens.push(Token::PARAMETER) if Token.param?(value)
    end

    # tokens.push(Token::VALUE) if Token.value?(tokens)

    tokens
  end

  private

  sig { params(tokens: TokenStream, stream: TokenStream).returns(CommandType) }
  def to_command(tokens, stream)
    Hash[tokens.map(&:to_sym).zip(stream)]
  end

  sig { params(expr: String).returns(TokenStream) }
  def chop(expr)
    expr.split(Regexp.union(Symbols::ALL)).map(&:strip)
  end

  # Determines whether a command is a known command (sushi.rb command)
  sig { params(sym: String).returns(T::Boolean) }
  def command?(sym)
    @loader.in_env? sym
  end
end
