class Hash
  def except!(*keys)
    keys.map! { |key| convert_key(key) } if respond_to?(:convert_key)
    keys.each { |key| delete(key) }
    self
  end
  
  def except(*keys)
    dup.except!(*keys)
  end
end unless Hash.method_defined?(:slice)