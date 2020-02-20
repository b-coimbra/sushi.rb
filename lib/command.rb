# typed: true
# frozen_string_literal: true

require_relative 'loader'
require_relative 'error'
require_relative 'parser'
require_relative 'history'

# Structure of a command's argument
class Argument < T::Enum
  enums do
    Parameter = new
    Value     = new
  end
end

# Handles the user input and dispatches commands
class Command
  extend T::Sig

  attr_reader :name
  attr_reader :description
  attr_reader :values

  CommandType = T.type_alias { T::Hash[Symbol, T.nilable(String)] }
  Commands    = T.type_alias { T::Array[CommandType] }

  sig { params(kwargs: String).void }
  def initialize(**kwargs)
    return if kwargs.empty?

    @commands = T.let([], Commands)
    @name     = T.let(kwargs[:name], T.nilable(String))

    @loader  = Loader.new
    @parser  = Parser.new
    @history = History.new

    self.name = @name
  end

  sig { params(name: String).void }
  def name=(name)
    # fix condition, return unknown only if it does not exist at all (not even in the OS).
    raise Error, T.cast(ErrorType::UnknownCommand, String) if name.empty?

    @commands = @parser.parse @name
  end

  sig { void }
  def execute
    return if @commands.nil?

    @commands.each do |command|
      @loader.load command[:name]

      argument_types = T.let([], T::Array[Argument])

      argument_types << Argument::Value     unless command[:values].nil?
      argument_types << Argument::Parameter unless command[:parameters].nil?

      check_args command, argument_types
    end
  end

  private

  sig { params(command: CommandType).void }
  def dispatch(command)
    name   = command[:name]
    params = command.collect { |_, v| v }.drop(1)

    send name, *params
    @history.store command.values.join(' ')
  end

  sig { params(command: CommandType, argument_types: T::Array[Argument]).void }
  def check_args(command, argument_types)
    raise Error, ErrorType::UnknownCommand if command.empty?

    dispatch command

    # if argument_types.include? ArgumentType::Value
    # end

    # if command[:parameters]
    #   if command[:values]
    #     dispatch T.must(command[:name]), T.must(command[:parameters]), T.must(command[:values])
    #   else
    #     dispatch T.must(command[:name]), T.must(command[:parameters])
    #   end
    # else
    #   dispatch T.must(command[:name])
    # end

  end
end
