# typed: true
# frozen_string_literal: true

require_relative 'loader'

# Describes all commands
class Help
  extend T::Sig

  def initialize
    @loader = Loader.new
  end

  def sheet
    puts "got help yo"
  end

  sig { params(command: String).void }
  def seek(command)
    @loader.load(command)

    description = @loader.metadata[:description]

    puts "#{command}: #{description}"
  end
end
