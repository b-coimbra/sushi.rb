# frozen_string_literal: true
require 'json'

# Reads all chat responses
class Parser
  def has_defined_speed?(section)
  end
end

# this is a documentation
class Chat
  attr_reader :responses

  def initialize
    @path = 'chat/'
    @responses = []

    # Dir.mkdir(@path) unless Dir.exist?(@path)

    fetchall
  end

  def fetchall
    Dir[@path + '*'].each do |responses|
      file = File.read(responses)

      # check if file is empty

      @responses << JSON.parse(file)
    end

    @responses.freeze
  end
end

chat = Chat.new

pp chat.responses.select { |res| res['unknown'] }
