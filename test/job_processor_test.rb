require 'minitest/autorun'
require './worker'

class JobProcessorTest < Minitest::Test
  def setup
    @job_processor = JobProcessor.new
  end

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
  end

  def test_process_success
    return_code = @job_processor.process(0.1)
    assert_equal  JobProcessor::SUCCESS, return_code
    assert_equal  0.1, @job_processor.last_time
  end

  def test_process_error
    return_code = @job_processor.process(2)
    assert_equal  JobProcessor::ERROR, return_code
    assert_equal  2, @job_processor.last_time
  end

  def test_to_s
    time = 0.1
    @job_processor.process(time)
    expect = "oid: #{@job_processor.object_id}, time: #{time}"
    assert_equal expect, @job_processor.to_s
  end

  def test_color
    JobProcessor.count = 1
    assert_equal :blue,  JobProcessor.new.color
    JobProcessor.count = 2
    assert_equal :green, JobProcessor.new.color
    JobProcessor.count = 3
    assert_equal :red,   JobProcessor.new.color
  end
end
