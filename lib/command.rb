# typed: true
# frozen_string_literal: true

require 'English'

require_relative 'loader'
require_relative 'error'
require_relative 'parser'
require_relative 'history'

require_relative 'types/argument'
require_relative 'ext/string'

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
    return if name.blank?

    @commands = @parser.parse name

    return if @commands.empty?

    @commands
      .filter { |command| [command[:system_command], command[:values]] }
      .each { |command| exec_sys(command) }
  end

  sig { void }
  def execute
    return if @commands.nil?

    @commands.each do |command|
      next if command[:system_command]

      @loader.load command[:name]

      arguments = T.let([], T::Array[Argument])

      arguments << Argument::Value     unless command[:values].nil?
      arguments << Argument::Parameter unless command[:parameters].nil?

      dispatch command
    end
  end

  private

  sig { params(command: CommandType).void }
  def dispatch(command)
    return if command.empty?

    name   = command[:name]
    params = command.collect { |_, v| v }.drop(1)

    send name, *params
    @history.store command.values.join(' ')
  end

  sig { params(command: String).returns(T::Boolean) }
  def sys_command?(command)
    system "which #{command}", err: File::NULL, out: File::NULL
    $CHILD_STATUS.success?
  end

  sig { params(commands: T::Hash[Symbol, T.nilable(String)]).void }
  def exec_sys(commands)
    puts commands

    return if commands.empty?

    commands.each do |_, command|
      puts command

      throw(ErrorType::UnknownCommand) unless sys_command? command

      if commands[:values] || commands[:parameters]
        if commands[:values]
          system(command, commands[:values])
          break
        end

        if commands[:values]
          system(command, commands[:values])
          break
        end

        if commands[:parameters]
          system(command, commands[:parameters])
          break
        end

        if commands[:values] && commands[:parameters]
          system(command, commands[:values], commands[:parameters])
          break
        end
      end

      system command

      @history.store(command)
    end
  end
end
