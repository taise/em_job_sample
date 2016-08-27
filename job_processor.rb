require 'eventmachine'

class JobProcessor
  include EM::Deferrable

  SUCCESS = 0
  ERROR = 1
  ANSI_COLOR_CODE = {
    red:   '\e[41',
    cyan:  '\e[46',
    green: '\e[42',
  }

  attr_reader :last_time
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

  def to_s
    "oid: #{object_id}, time: #{@last_time}"
  end

  private

  def color
    if @color.nil?
      @color = [:red, :cyan, :green][@@count % 3]
      @@count += 1
    end
    @color
  end

  def ansi_color_code
    ANSI_COLOR_CODE[color]
  end
end
