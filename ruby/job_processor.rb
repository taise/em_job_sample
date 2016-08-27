require 'eventmachine'

class JobProcessor
  include EM::Deferrable

  SUCCESS = 0
  ERROR = 1

  def process(time)
    if time == 2
      return ERROR
    end
    sleep time
    return SUCCESS
  end
end
