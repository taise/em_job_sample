require 'minitest/autorun'
require './worker'

class JobProcessorTest < Minitest::Test
  def test_fixed_values
    assert_equal 0, JobProcessor::SUCCESS
    assert_equal 1, JobProcessor::ERROR
  end

  def fixed_values
    [JobProcessor::SUCCESS, JobProcessor::ERROR]
  end

  def test_process
    time, return_code = JobProcessor.new.process
    assert (0..2).include? time
    assert fixed_values.include? return_code
  end
end
