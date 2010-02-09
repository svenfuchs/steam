class String
  def camelize
    split(/[^a-z0-9]/i).map { |w| w.capitalize }.join
  end
end unless String.method_defined?(:camelize)