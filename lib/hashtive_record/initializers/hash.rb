class Hash
  def to_ostruct
    arr = map do |k, v|
      case v
      when Hash
        [k, v.to_ostruct]
      when Array
        [k, v.map { |el| Hash === el ? el.to_ostruct : el }]
      else
        [k, v]
      end
    end
    OpenStruct.new(arr)
  end
end