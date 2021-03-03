# frozen_string_literal: true
# rubocop:disable Layout/HashAlignment, Naming/ConstantName

require 'singleton'

module ErrorType
  FileNotFound   = 0
  UnknownFlag    = 1
  UnknownCommand = 2
  UnknownError   = 3
  NoLibraries    = 4
  EmptyMetadata  = 5
  ParseError     = 6
  InvalidPath    = 7
end

# Custom error class
class Error < StandardError
  include ErrorType
  include Singleton

  attr_writer :message

  def initialize(type)
    @message = {
      ErrorType::UnknownCommand => 'Command does not exist.',
      ErrorType::EmptyMetadata  => 'The util does not have any metadata defined.',
      ErrorType::NoLibraries    => 'There are no utils to execute.',
      ErrorType::InvalidPath    => 'Invalid utility path.',
      ErrorType::ParseError     => 'Error parsing command metadata.',
      ErrorType::FileNotFound   => 'Unable to access the specified file.'
    }[type]

    super @message
  end
end

def throw(type = ErrorType::UnknownError)
  raise Error, type
end
