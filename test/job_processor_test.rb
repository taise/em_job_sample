require 'minitest/autorun'
require './worker'

class JobProcessor
  # for testable colors
  def self.count=(n)
    @@count = n
  end
end

class JobProcessorTest < Minitest::Test
  RED   = 0
  CYAN  = 1
  GREEN = 2

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
    assert_equal nil, JobProcessor.new.last_time

    JobProcessor.count = RED
    assert_equal :red, JobProcessor.new.send(:color)
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

  def test_color_and_ansi_color_code
    JobProcessor.count = RED
    job_processor = JobProcessor.new
    assert_equal :red,    job_processor.send(:color)
    assert_equal "\e[31m", job_processor.send(:ansi_color_code)

    JobProcessor.count = CYAN
    job_processor = JobProcessor.new
    assert_equal :cyan,   job_processor.send(:color)
    assert_equal "\e[36m", job_processor.send(:ansi_color_code)

    JobProcessor.count = GREEN
    job_processor = JobProcessor.new
    assert_equal :green,  job_processor.send(:color)
    assert_equal "\e[32m", job_processor.send(:ansi_color_code)
  end
end
