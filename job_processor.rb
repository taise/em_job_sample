require 'eventmachine'

class JobProcessor
  include EM::Deferrable

  SUCCESS = 0
  ERROR = 1
  ANSI_COLOR_CODE = {
    red:   "\e[31m",
    cyan:  "\e[36m",
    green: "\e[32m",
    reset: "\e[0m"
  }

  attr_reader :last_time
  def initialize
    @@count ||= 0
    @last_time
  end

  def process(time)
    @last_time = time
    color_print
    if time == 2
      return ERROR
    end
    sleep time
    return SUCCESS
  end

  def to_s
    "oid: #{object_id}, time: #{@last_time}"
  end

  def color_print
    print ansi_color_code + self.to_s + ANSI_COLOR_CODE[:reset] + "\n"
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
