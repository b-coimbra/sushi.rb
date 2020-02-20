# frozen_string_literal: true

require_relative 'ext/string'

module Keywords
  PROMPT = '$PROMPT'
  COLOR  = '$COLOR'
end

# Parses the config file
class Config
  include Keywords

  attr_reader :settings

  def initialize
    @settings = []
    @file = File.expand_path('sushirc') # TODO: Move this to ~/

    read @file

    p @settings
  end

  private

  def comment?(line)
    true if line[/^#/m]
  end

  def variable?(line)
    true if line[/^\$/]
  end

  def get_value(variable)
    variable.split(/\=/im).map(&:strip)
  end

  def read(config)
    File.open(config, 'r').each_line do |line|
      unless comment?(line) || line.blank?
        p get_value(line) if variable?(line)
      end
    end
  end

  def settings=(key, value)
    @settings.append(key => value)
  end
end
