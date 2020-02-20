# frozen_string_literal: true

# Parses the config file and returns a hash of options
class Config
  def initialize file
    @file = file
  end

  def parse
    keywords = %w(PROMPT COLOR)
    keyword  = ''
    tokens   = []
    is_key   = false
    is_value = false
    keywords = /"([^"]+)"|(\S+)/

    File.open(@file).each do |line|
      next if line[/^\#/]

      line.scan(keyword).flatten.compact.each do |word|
        puts word
        next if word == []

        if is_value
          tokens << [keyword, word]
          is_key = is_value = false
        end

        if keywords.include? word
          is_key  = true
          keyword = word
        end

        is_value = true if is_key && word == '='
      end
    end

    tokens
  end

  # parse_config.each { |k, v| eval "$#{k} = '#{v}'" }

  # p parse_config

  #  default prompt in case the config file is deleted
  #$PROMPT = $PROMPT || '\W $ '
  #
  #prompt_strings = {
  #  n: "\n",
  #  t: "\t",
  #  W: Dir.pwd
  #}
  #
  #prompt_strings.each { |k, v| $PROMPT = $PROMPT.gsub("\\#{k}", v) }
  #
  #print $PROMPT
end
