require 'eventmachine'

class JobProcessor
  include EM::Deferrable

  SUCCESS = 0
  ERROR = 1

  attr_reader :color, :last_time
  def initialize
    @@count ||= 0
    @last_time
  end

  def self.count=(n)
    @@count = n
  end

  def process(time)
    @last_time = time
    puts self.to_s
    if time == 2
      return ERROR
    end
    sleep time
    return SUCCESS
  end

  def color
    if @color.nil?
      @color = [:red, :blue, :green][@@count % 3]
      @@count += 1
    end
    @color
  end

  def to_s
    "oid: #{object_id}, time: #{@last_time}"
  end
end
