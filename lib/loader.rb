# typed: true
# frozen_string_literal: true

require_relative 'ext/string'
require_relative 'error'
require_relative 'serializer'

# Populates an environment of user and core defined libraries (commands)
class Loader
  extend T::Sig

  attr_reader :environment
  attr_reader :loaded_libs

  def initialize
    @serializer = Serializer.new

    @environment = T.let([], T::Array[T::Hash[String, String]])
    @loaded_libs = T.let([], T::Array[String])

    populate_env
  end

  sig { returns(T::Hash[Symbol, T.any(String, T::Array[Symbol])]) }
  def metadata
    @serializer.metadata
  end

  def in_env?(name)
    !@environment.select { |util| util[name] }.empty?
  end

  sig { params(name: T.nilable(String)).void }
  def load(name)
    return if name.nil? || @environment.empty?
    return if @loaded_libs.include? name

    lib = @environment.select { |util| util[name] }

    raise Error, T.cast(ErrorType::NoLibraries, String) if lib.empty?

    T.must(lib.first).values.collect do |path|
      require_relative path
      read_util path
    end

    @loaded_libs.push(name)
  end

  private

  sig { void }
  def populate_env
    Dir[File.join(__dir__, '/', %w[utils], '*.rb')].each do |path|
      raise Error, T.cast(ErrorType::InvalidPath, String) if path.empty?
      @environment.push(File.basename(path, '.rb') => path)
    end
  end

  sig { params(util: String).void }
  def read_util(util)
    metadata = T.must(File.read(util).split(/^__END__$/).last).strip.split("\n")

    raise Error, T.cast(ErrorType::EmptyMetadata, String) if metadata.empty?

    @serializer.transform(metadata)
  end
end
