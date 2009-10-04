class Array
  def flatten_once
    result = []
    for element in self # a little faster than each
      result.push(*element)
    end
    result
  end
end