def pipe_it(input, filter)
  return input.map { |input_item| pipe_it(input_item, filter) } if input.is_a? Array

  case filter
  when Symbol
    input.send(filter)
  when Hash
    method = filter.keys.first
    arguments = Array(filter.values.first)
    input.send(method, *arguments)
  when Array
    filter.map { |filter_item| pipe_it(input, filter_item) }
  else
    filter.call(input)
  end
end

class Pipeline
  def initialize(*filters)
    @filters = filters
  end

  attr_accessor :filters

  def call(input)
    filters.inject(input) do |input, filter|
      pipe_it(input, filter)
    end
  end
end

def pipable(input)
  input.define_singleton_method(:|) { |filter| pipable pipe_it(input, filter) }
  return input
end

define_method(:pipe) { |input, *pipeline| Pipeline.new(*pipeline).call(input) }