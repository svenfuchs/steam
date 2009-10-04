class String
  def underscore
    self[0, 1].downcase + self[1..-1].gsub(/[A-Z]/) { |c| "_#{c.downcase}" }
  end
end