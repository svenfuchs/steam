require File.expand_path('../test_helper', __FILE__)

class ProcessTest < Test::Unit::TestCase
  include Steam

  def setup
    delete_pid
  end

  def teardown
    delete_pid
  end

  def write_pid(pid)
    File.open('/tmp/steam.pid', 'w') { |f| f.write(pid) }
  end

  def delete_pid
    File.delete('/tmp/steam.pid') rescue Errno::ENOENT
  end

  test "new instance recalls an existing pid" do
    write_pid(1234)
    assert_equal 1234, Process.new.pid
  end

  test "pid? returns true if pid was recalled" do
    write_pid(1234)
    assert_equal true, Process.new.pid?
  end

  test "pid? returns false if pid could not be recalled" do
    assert_equal false, Process.new.pid?
  end

  test "running? returns true if pid refers to an existing process" do
    write_pid(::Process.pid)
    assert_equal true, Process.new.running?
  end

  test "running? returns false if pid does not refer to an existing process" do
    write_pid(1073741823)
    assert_equal false, Process.new.running?
  end

  # # WTF the child process actually writes to /tmp/out.txt but File.read('/tmp/out.txt')
  # # returns an empty string
  # test "fork forks the process, reopens given streams and yields the given block" do
  #   File.delete('/tmp/out.txt') rescue Errno::ENOENT
  #   io = File.open('/tmp/out.txt', 'w+')
  #   io.sync = true
  #   Process.new.fork(:out => io) { puts 'foo' }
  #   assert_equal 'foo', File.open('/tmp/out.txt', 'r') { |f| f.read }
  # end
end