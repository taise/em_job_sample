class JobStatus
  def initialize
    @done = 0
    @failed = 0
    @scheduled = 0
  end

  def start
    @scheduled += 1
  end

  def success
    @done += 1
  end

  def fail
    @failed += 1
  end

  def print
    puts "done: #{@done}, scheduled: #{@scheduled}"
  end
end
