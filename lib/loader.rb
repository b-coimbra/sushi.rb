require_relative 'error'
require_relative 'serializer'

class Loader
  attr_reader :environment
  attr_reader :loaded_libs

  def initialize
    @serializer  = Serializer.new
    @environment = []
    @loaded_libs = []

    populate_environment
  end

  def populate_environment
    Dir[File.join(%w[utils], '*.rb')].each do |path|
      if path.length
        @environment.push(File.basename(path, '.rb') => path)
      else
        raise Error, ErrorType::InvalidPath
      end
    end
  end

  def read_util util
    metadata = File.read(util).split(/^__END__$/).last.strip.split("\n")

    unless metadata.empty?
      return @serializer.transform(metadata)
    else
      raise Error, ErrorType::EmptyMetadata
    end
  end

  def load_util name
    return if @loaded_libs.include?(name)

    if name && @environment
      lib = @environment.select { |util| util[name] }

      unless lib.empty?
        lib.first.values.collect { |path| require_relative path; read_util path }
        @loaded_libs.push(name)
      else
        raise Error, ErrorType::NoLibraries
      end
    end
  end
end
