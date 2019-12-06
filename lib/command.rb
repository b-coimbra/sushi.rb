require_relative 'loader'
require_relative 'error'
require_relative 'parser'

class Command
  attr_accessor :name
  attr_writer :commands

  def initialize
    @loader = Loader.new
    @parser = Parser.new
  end

  def execute
    @commands.each do |command|
      @loader.load_util command[:name]

      if command[:parameters]
        send command[:name], command[:parameters]
      else
        send command[:name]
      end
    end
  end

  def name=(name)
    unless name.blank?
      @name = name
      @commands = @parser.parse @name
    else
      raise Error, ErrorType::UnknownCommand
    end
  end
end
