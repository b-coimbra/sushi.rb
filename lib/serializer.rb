# typed: true
# frozen_string_literal: true

require_relative 'error'

# Reads a command file and returns its metadata
class Serializer < T::Struct
  extend T::Sig

  include ErrorType

  Result = T.type_alias { T::Hash[Symbol, T.any(String, T::Array[Symbol])] }

  prop :metadata, Result, default: {}

  sig { params(metadata: T::Array[String]).returns(T.any(Result, Error)) }
  def transform(metadata)
    result = T.let({}, Result)

    metadata.each { |data| result.store(*data.split(':').map(&:strip)) }
    result.transform_keys!(&:to_sym)

    begin
      result.store(:args, parameters(result[:method]))
    rescue NameError
      raise Error, T.cast(ErrorType::ParseError, String)
    end

    self.metadata = result
  end

  private

  sig { params(command: String).returns(T::Array[Symbol]) }
  def parameters(command)
    method(command)
      .parameters
      .flatten
      .reject { |param| param == :req }
  end
end
