Dir[File.dirname(__FILE__) + '/**/*_test.rb'].each do |filename|
  require filename unless filename.include?('_locator')
end