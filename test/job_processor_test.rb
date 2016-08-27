require 'minitest/autorun'
require './worker'

class JobProcessorTest < Minitest::Test
  def fixed_values
    [JobProcessor::SUCCESS, JobProcessor::ERROR]
  end

  def test_fixed_values
    assert_equal 0, JobProcessor::SUCCESS
    assert_equal 1, JobProcessor::ERROR
  end

  def test_initialized
    assert_equal nil,   JobProcessor.new.last_time

    JobProcessor.count = 0
    assert_equal :red,   JobProcessor.new.color
    assert_equal :blue,  JobProcessor.new.color
    assert_equal :green, JobProcessor.new.color
  end

  def test_process
    job_processor = JobProcessor.new
    return_code = job_processor.process(1)
    assert_equal  JobProcessor::SUCCESS, return_code
    assert_equal  1, job_processor.last_time

    job_processor = JobProcessor.new
    return_code = job_processor.process(2)
    assert_equal  JobProcessor::ERROR, return_code
    assert_equal  2, job_processor.last_time
  end
end
