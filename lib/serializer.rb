class Serializer
  def transform metadata
    result = {}
    metadata.map { |data| result.store(*data.split(':').map(&:strip)) }
    result.transform_keys!(&:to_sym)
    result.store(:args, method(result[:method]).parameters)

    return result
  end
end
