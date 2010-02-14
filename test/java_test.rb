require File.expand_path('../test_helper', __FILE__)


class JavaTest < Test::Unit::TestCase
  include Steam
  include Java::AutoDefine
  extend Java::AutoDefine

  test "pop_name" do
    name = 'A::B::C'
    assert 'A', pop_name(name)
    assert 'B', pop_name(name)
    assert 'C', pop_name(name)
  end
  
  test "const_set_nested" do
    const = self.class.const_set_nested('A::B::C', Module.new)
    assert_equal A::B::C, const
  end
  
  test "java_path_to_const_name" do
    assert_equal 'Util::ArrayList', Java.path_to_const_name("java.util.ArrayList")
  end
  
  test "import" do
    const = Java.import('java.util.Set')
    assert_equal Java::Util::Set, const
  end
end