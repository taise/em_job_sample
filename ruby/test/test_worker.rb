require 'minitest/autorun'
require './worker'

class WokerTest < Minitest::Test
  def test_fixed_values
    assert_equal 0, Worker::SUCCESS
    assert_equal 1, Worker::ERROR
  end

  def test_process
    time, return_code = Worker.new.process
    assert (0..2).include? time
    assert [Worker::SUCCESS, Worker::ERROR].include? return_code
  end
end
