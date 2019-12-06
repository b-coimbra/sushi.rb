require_relative 'symbols'
require_relative 'error'
require_relative 'ext/string'

class Parser
  include Symbols

  def parse chain
    chain = chain.split(Symbols::AND).map &:strip
    commands = []

    chain.each do |command|
      commands.push(Hash[[:name, :parameters].zip(command.split "\s")])
    end

    unless commands.empty?
      return commands
    else
      raise Error, ErrorType::ParseError
    end
  end

  def tokenize
    Symbols::ALL.each do |sym|
      if command.kind_of? Array
        command.each_with_index do |c, i|
          if has_sym? command[i], sym
            command[i] = separate(command[i], sym)
          end
        end
      else
        if has_sym? command, sym
          command = separate(command, sym)
        end
      end
    end
  end

  def has_sym? expr, sym
    p expr + sym
    expr.match sym.to_regex
  end

  def separate expr, sym
    expr.split sym.to_regex
  end
end
